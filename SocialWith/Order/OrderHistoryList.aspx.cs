using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Comm;
using SocialWith.Biz.Document;
using Urian.Core;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.ComponentModel.DataAnnotations;
using System.Drawing;
using System.Reflection;
using System.Data;

public partial class Order_OrderHistoryList : PageBase
{
    CommService commService = new CommService();

    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        orderCss.Text = string.Format("<link rel=\"stylesheet\" type=\"text/css\" href=\"{0}\"/>", "../Content/Order/order.css?dt=" + DateTime.Now.ToString("yyyyMMddhhmmss"));
        if (IsPostBack == false)
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
        //PayWayDataBind();      
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
                //if(item.Map_Type != 0 && item.Map_Type < 500) 
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
                if (item.Map_Type != 0 )
                {
                   
                    ddlPayWay.Items.Add(new ListItem(item.Map_Name, item.Map_Type.AsText()));
                }
            }
        }
    }


    #endregion

    #region << 엑셀 파일 저장 >>
    protected void btnOrdHistoryExcel_Click(object sender, ImageClickEventArgs e)
    {
        string ordStat = ddlOrderStatus.SelectedValue;
        string payway = ddlPayWay.SelectedValue;
        this.txtSearchSdate.Text = Request[this.txtSearchSdate.UniqueID];
        this.txtSearchEdate.Text = Request[this.txtSearchEdate.UniqueID];
        string todateB = this.txtSearchSdate.Text;
        string todateE = this.txtSearchEdate.Text;
        string ordCodeNo = txtOrderNo.Text;
        string brand = txtBrand.Text;
        string gdsName = txtGoodsName.Text;
        string gdsCode = txtGoodsCode.Text;

        string userRole = UserInfoObject.Svid_Role.AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", Svid_User},
            {"nvar_P_ORDERSTATUS", ordStat.AsText()},
            {"nvar_P_PAYWAY", payway.AsText()},
            {"nvar_P_TODATEB", todateB.AsText()},
            {"nvar_P_TODATEE", todateE.AsText()},
            {"nvar_P_ORDERCODENO", ordCodeNo.AsText()},
            {"nvar_P_BRAND", brand.AsText()},
            {"nvar_P_GOODSFINALNAME", gdsName.AsText()},
            {"nvar_P_GOODSCODE", gdsCode.AsText()}
        };

        SocialWith.Biz.Order.OrderService orderService = new SocialWith.Biz.Order.OrderService();
        SocialWith.Biz.Excel.ExcelService excelService = new SocialWith.Biz.Excel.ExcelService();
        if (userRole.Equals("A1"))
        {
            var table = excelService.GetExcelOrderHistoryList(paramList);
            for (int rowIndex = 0; rowIndex < table.Rows.Count; rowIndex++)
            {
                table.Rows[rowIndex]["GOODSFINALNAME"] = "[" + table.Rows[rowIndex]["BRANDNAME"] + "]" + table.Rows[rowIndex]["GOODSFINALNAME"] + "\n" + table.Rows[rowIndex]["GOODSOPTIONSUMMARYVALUES"];
            }
            table.Columns.Remove("COMPANYDEPT_NAME");
            table.Columns.Remove("BUDGETACCOUNTNAME");
            table.Columns.Remove("BRANDNAME");
            table.Columns.Remove("GOODSOPTIONSUMMARYVALUES");
            string[] headerName = { "번호", "주문일자", "주문번호", "판매사", "주문자","요청자", "상품코드", "주문상품정보", "모델명", "내용량", "주문금액", "수량", "출항예정일", "배송완료일", "주문처리현황", "결제수단" };

            var fileName = Server.UrlEncode(UserId + "_주문내역");
            

            ExportExcel(fileName, headerName, table ,"A");
        }
        else
        {
            var table = excelService.GetExcelOrderHistoryList(paramList);
            for (int rowIndex = 0; rowIndex < table.Rows.Count; rowIndex++)
            {
                table.Rows[rowIndex]["GOODSFINALNAME"] = "[" + table.Rows[rowIndex]["BRANDNAME"] + "]" + table.Rows[rowIndex]["GOODSFINALNAME"] + "\n" + table.Rows[rowIndex]["GOODSOPTIONSUMMARYVALUES"];
            }
            table.Columns.Remove("BRANDNAME");
            table.Columns.Remove("GOODSOPTIONSUMMARYVALUES");
            string[] headerName = { "번호", "주문일자", "주문번호", "판매사", "주문자", "요청자", "상품코드", "상품정보", "모델명", "내용량", "주문금액", "수량", "예산부서", "예산계정",  "출하예정일", "배송완료일", "주문처리현황", "결제수단" };
            var fileName = Server.UrlEncode(UserId + "_주문내역");

            ExportExcel(fileName, headerName, table, "B");
        }
    }

    public void ExportExcel(string fileName, string[] headerNames, DataTable table, string type)
    {


        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("주문조회내역");

            //Format the Title
            using (ExcelRange rng = ws.Cells[2, 8, 3, 11])
            {
                rng.Value = "주문내역조회";
                rng.Merge = true;
                rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                rng.Style.Font.Bold = true;
                //rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      
                rng.Style.Border.Top.Style = ExcelBorderStyle.Medium;
                rng.Style.Border.Left.Style = ExcelBorderStyle.Medium;
                rng.Style.Border.Right.Style = ExcelBorderStyle.Medium;
                rng.Style.Border.Bottom.Style = ExcelBorderStyle.Medium;

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
                int deliveryDateColIndex = 0;
                int goodsInfoIndex = 0;
                int priceIndex = 0;
                if (type == "A")
                {
                    deliveryDateColIndex = 13;
                    goodsInfoIndex = 7;
                    priceIndex = 10;
                }
                else
                {
                    deliveryDateColIndex = 16;
                    goodsInfoIndex = 8;
                    priceIndex = 11;
                }

                ws.Cells["A6"].LoadFromDataTable(table, false);

                ws.Cells[6, goodsInfoIndex, table.Rows.Count + 5, goodsInfoIndex].Style.WrapText = true;   //상품정보
                ws.Cells[6, 2, table.Rows.Count + 5, 2].Style.Numberformat.Format = "yyyy-MM-dd"; // 날짜포맷
                ws.Cells[6, deliveryDateColIndex, table.Rows.Count + 5, deliveryDateColIndex].Style.Numberformat.Format = "yyyy-MM-dd"; // 날짜포맷
                ws.Cells[6, priceIndex, table.Rows.Count + 5, priceIndex].Style.Numberformat.Format = "#,###원"; //주문금액


                int colRange = 0;

                if (type == "A")
                {
                    colRange = 15;
                }
                else
                {
                    colRange = 18;
                }

                //Format the header
                using (ExcelRange rng = ws.Cells[5, 1, 5, colRange])
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
                using (ExcelRange rng = ws.Cells[6, 1, table.Rows.Count + 4, colRange])
                {
                    rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

                }
                //셀 사이즈 오토 세팅
                using (ExcelRange rng = ws.Cells[5, 1, table.Rows.Count + 5, colRange])
                {
                    rng.AutoFitColumns();
                }

                for (int i = 5; i <= table.Rows.Count+4; i++)
                {
                    ws.Row(i + 1).Height = 36;
                }

                //상품정보 Cell Width세팅 (Wraptext가 true로 설정되있으면 AutoFitColumns이 안먹는다...)
                ExcelRange columnCells = ws.Cells[6, goodsInfoIndex, table.Rows.Count+4, goodsInfoIndex];
                int maxLength = columnCells.Max(cell => cell.Value.ToString().Count(c => char.IsLetterOrDigit(c)));
                columnCells.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                ws.Column(goodsInfoIndex).Width = maxLength + 20; // 2 is just an extra buffer for all that is not letter/digits.
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