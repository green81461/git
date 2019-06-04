using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Order;
using Urian.Core;
using SocialWith.Biz.Excel;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;

public partial class Order_OrderBillList : PageBase
{
    OrderService orderService = new OrderService();

    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        DefaultDataBind();
    }

    #region <<데이터바인드>>
    protected void DefaultDataBind()
    {
        var paramList = new Dictionary<string, object> {
            { "nvar_P_SVID_USER", Svid_User },
        };

        var info = orderService.GetGoodsLoanInfo(paramList);
        
        if(info != null)
        {
            var LoanCalDue = info.LoanCalDue;
            var Due = "";
            var Due2 = "";

            if (LoanCalDue.AsInt() == 0)
            {
                Due = "당월 ";
            }
            else if (LoanCalDue.AsInt() == 30)
            {
                Due = "익월 ";
            }
            else if (LoanCalDue.AsInt() == 60)
            {
                Due = "익익월 ";
            }
            else if (LoanCalDue.AsInt() == 90)
            {
                Due = "익익익월 ";
            }
            else
            {
                Due = "익익익익월 ";
            }

            if (LoanCalDue.AsInt() > info.LoanBillDate.AsInt())
            {
                Due2 = "익월 ";
            }
            else
            {
                Due2 = "당월 ";
            }

            lbLoadEndDate.Text = "당월 " + info.LoanEndDate + "일";
            lbLoadBillDate.Text = Due2 + info.LoanBillDate + "일";
            lbLoadPayDate.Text = Due + info.LoanPayDate + "일";

            SetDate(info.LoanEndDate); //히든필드에 날짜세팅
        }
        
    }

    //히든필드에 날짜세팅
    protected void SetDate(String d)
    {
        var year = DateTime.Now.ToString("yyyy");//현재년도
        var month = DateTime.Now.ToString("MM"); //현재달
        var LastMonth = DateTime.Now.AddMonths(-1).ToString("MM"); ; //전월      

        //var endDate = DateTime.Now.ToString(year + "-" + month + "-" + d);//고정값
        var nowDate = DateTime.Now.ToString(year + "-" + month + "-" + d); //(day + 1)만 적용
        var startDate = nowDate.AsDateTime().AddDays(+1).ToString("dd");
        var startDate2 = "";
        if (startDate.AsInt() < d.AsInt())
        {
            startDate2 = DateTime.Now.ToString("MM"); //(month - 1)만 적용
        }
        else
        {
            startDate2 = DateTime.Now.AddMonths(-1).ToString("MM");
        }


        hdSartDate.Value = DateTime.Now.ToString(year + "-" + startDate2 + "-" + startDate);
        hdEndDate.Value = DateTime.Now.ToString(year + "-" + month + "-" + d);
    }

    #endregion

    #region <<엑셀다운 이벤트>>
    protected void btnExcel_Click(object sender, EventArgs e)
    {

        ExcelService excelService = new ExcelService();

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_SVID_USER", Svid_User},
            {"nvar_P_SEARCHENDDATE", hdEndDate.Value.AsText()}
        };
        var table = excelService.GetExcelOrderMonthDeadLineList(paramList); //구매사 정산 마감신청 내역 엑셀용 조회

        for (int i = 0; i < table.Rows.Count; i++)
        {
            
            table.Rows[i]["GOODSFINALNAME"] = table.Rows[i]["GOODSFINALNAME"] + "\n" + table.Rows[i]["GOODSOPTIONSUMMARYVALUES"];
        }

        table.Columns.Remove("GOODSOPTIONSUMMARYVALUES");
        table.Columns.Remove("ORDERENTERYN");

        string[] headerName = { "번호", "입금일자", "배송완료일", "주문번호", "상품코드", "주문상품정보", "상품단가", "주문\n수량", "주문금액", "마감현황" };
        var fileName = Server.UrlEncode(UserId + "_정산마감신청내역");
        ExportExcel(fileName, headerName, table);
    }

    public void ExportExcel(string fileName, string[] headerNames, DataTable table)
    {
        using (ExcelPackage pck = new ExcelPackage())
        {
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("정산 마감신청내역");
            int headerIndex = 0;
            int colCount = 10;

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
                rng.Value = "  정산 마감신청내역 (" + DateTime.Now.ToString("MM") + "월분)";
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
                ws.Cells[5, 8, 5, 8].Style.WrapText = true;

                ws.Cells["A6"].LoadFromDataTable(table, false);

                ws.Cells[6, 2, table.Rows.Count + 5, 3].Style.Numberformat.Format = "yyyy-MM-dd";
                ws.Cells[6, 6, table.Rows.Count + 5, 6].Style.WrapText = true;
                ws.Cells[6, 8, table.Rows.Count + 5, 8].Style.WrapText = true;
                ws.Cells[6, 7, table.Rows.Count + 5, 7].Style.Numberformat.Format = "#,###0원";
                ws.Cells[6, 9, table.Rows.Count + 5, 9].Style.Numberformat.Format = "#,###0원";

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
                
                //상품정보 Cell Width세팅(Wraptext가 true로 설정되있으면 AutoFitColumns이 안 먹음)
                ExcelRange columnCells = ws.Cells[6, 6, table.Rows.Count + 5, 6];
                columnCells.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;

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
    #endregion
}