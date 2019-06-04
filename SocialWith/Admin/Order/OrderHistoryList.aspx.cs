using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Comm;
using Urian.Core;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using SocialWith.Biz.Excel;
using System.Drawing;
using System.Data;
using SocialWith.Biz.Pay;
using Newtonsoft.Json;
using SocialWith.Data.Comm;
using System.Text.RegularExpressions;

public partial class Admin_Order_OrderHistoryList :AdminPageBase
{
    PayService payService = new PayService();
    CommService commService = new CommService();

    protected String OrdStatCodes = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            DefaultDataBind();
        }
    }

    #region <<데이터바인드>>
    protected void DefaultDataBind()
    {
        GetPayStatus();
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

        var statLIst = new List<CommDTO>();

        if ((list != null) && (list.Count > 0))
        {
            foreach (var item in list)
            {
                if (item.Map_Type != 0 && item.Map_Type < 500)
                {
                    ddlOrderStatus.Items.Add(new ListItem(item.Map_Name, item.Map_Type.AsText()));
                }
            }

            foreach (var statItem in list)
            {
                if ((statItem.Map_Type != 0) && (statItem.Map_Type != 101) && (statItem.Map_Type != 102) && (statItem.Map_Type != 201) && (statItem.Map_Type != 206) && (statItem.Map_Type < 300))
                {
                    statLIst.Add(statItem);
                }
            }

            OrdStatCodes = JsonConvert.SerializeObject(statLIst); //JSON 형식으로 변수에 저장
        }
    }

    protected void GetPayStatus()
    {

        var paramList = new Dictionary<string, object> {
           
        };

        var info = payService.GetCurrentPayAdminStatus(paramList);
        var value = string.Empty;
        if (!string.IsNullOrWhiteSpace(info))
        {
            value = info.AsDecimal().ToString("#,###");
        }
        else
        {
            value = "0";
        }
        lblPayStatus1.Text = DateTime.Now.Month + "월 총 주문금액 (VAT포함)";
        lblPayStatus2.Text = value + "원";
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
    
    public void ExportExcel(string fileName, string[] headerNames, DataTable table)
    {


        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("주문내역조회");
            int headerIndex = 0;
            int colCount =37;
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
                this.txtSearchSdate.Text = Request[this.txtSearchSdate.UniqueID];
                this.txtSearchEdate.Text = Request[this.txtSearchEdate.UniqueID];
                rng.Value = "  주문내역조회 (" + txtSearchSdate.Text.Trim() + " ~ " + txtSearchEdate.Text.Trim() + ")";
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

                
                ws.Cells[6, 2, table.Rows.Count + 5, 2].Style.Numberformat.Format = "yyyy-MM-dd";
                ws.Cells[6, 14, table.Rows.Count + 5, 14].Style.WrapText = true; // 상품정보 데이터
                ws.Cells[5, 28, 5, 29].Style.WrapText = true; // 헤더 줄바꿈
                ws.Cells[5, 31, 5, 31].Style.WrapText = true; // 헤더 줄바꿈
                ws.Cells[5, 33, 5, 35].Style.WrapText = true; // 헤더 줄바꿈

                ws.Cells[6, 19, table.Rows.Count + 5, 19].Style.Numberformat.Format = "yyyy-MM-dd";
                
                ws.Cells[6, 28, table.Rows.Count + 5, 29].Style.Numberformat.Format = "#,###0원";
                ws.Cells[6, 31, table.Rows.Count + 5, 31].Style.Numberformat.Format = "#,###0원";
                ws.Cells[6, 33, table.Rows.Count + 5, 35].Style.Numberformat.Format = "#,###0원";

                ws.Cells[6, 30, table.Rows.Count + 5, 30].Style.Numberformat.Format = "#0.00%";
                ws.Cells[6, 32, table.Rows.Count + 5, 32].Style.Numberformat.Format = "#0.00%";
                ws.Cells[6, 36, table.Rows.Count + 5, 36].Style.Numberformat.Format = "#0.00%";


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

                //상품정보 Cell Width세팅(Wraptext가 true로 설정되있으면 AutoFitColumns이 안먹는다...)
                ExcelRange columnCells = ws.Cells[6, 14, table.Rows.Count + 5, 14];
                columnCells.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                int maxLength = columnCells.Max(cell => cell.Value.ToString().Count(c => char.IsLetterOrDigit(c)));


                ws.Column(14).Width = maxLength + 20; // 2 is just an extra buffer for all that is not letter/digits.
                ws.Column(28).Width = 15; //매입단가(AA)
                ws.Column(29).Width = 15; //판매사단가(AB)
                ws.Column(31).Width = 16; //구매사단가(AD)
                ws.Column(33).Width = 17; //매입금액합계(AF)
                ws.Column(34).Width = 17; //판매사금액합계(AG)
                ws.Column(35).Width = 17; //구매사금액합계(AH)
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
        var param = new Dictionary<string, object> {
            { "nvar_P_ORDERSTATUS", ddlOrderStatus.SelectedValue},
            { "nvar_P_PAYWAY", ddlPayWay.SelectedValue},
            { "nvar_P_TODATEB", txtSearchSdate.Text.Trim()},
            { "nvar_P_TODATEE", txtSearchEdate.Text.Trim()},
            { "nvar_P_ORDERCODENO", txtOrderNo.Text.Trim()},
            { "nvar_P_BRAND", txtBrand.Text.Trim()},
            { "nvar_P_GOODSFINALNAME", txtGoodsName.Text.Trim()},
            { "nvar_P_GOODSCODE", txtGoodsCode.Text.Trim()},
            { "nvar_P_SALECOMPNAME", txtSaleCompName.Text.Trim()},
            { "nvar_P_BUYCOMPNAME", txtBuyCompName.Text.Trim()},
        };

        var table = excelService.GetExcelAdminOrderHistoryList(param);
        for (int rowIndex = 0; rowIndex < table.Rows.Count; rowIndex++)
        {
            //table.Rows[rowIndex]["GOODSCUSTPRICEVAT"] = (table.Rows[rowIndex]["SOCIALSALEVAT"]).AsText() == "0" ? "MRO" : ((table.Rows[rowIndex]["SOCIALSALEVAT"]).AsDecimal()).AsText();
            //table.Rows[rowIndex]["CUSTSALEVAT"] = (table.Rows[rowIndex]["CUSTSALEVAT"]).AsText() == "0" ? "MRO" : ((table.Rows[rowIndex]["CUSTSALEVAT"]).AsDecimal()).AsText();
            //table.Rows[rowIndex]["TOTDONGGOODSCUSTPRICEVAT"] = (table.Rows[rowIndex]["TOTDONGGOODSCUSTPRICEVAT"]).AsText() == "0" ? "MRO" : ((table.Rows[rowIndex]["TOTDONGGOODSCUSTPRICEVAT"]).AsDecimal()).AsText();
            table.Rows[rowIndex]["GOODSFINALNAME"] = "[" + table.Rows[rowIndex]["BRANDNAME"] + "]" + table.Rows[rowIndex]["GOODSFINALNAME"] + "\n" + table.Rows[rowIndex]["GOODSOPTIONSUMMARYVALUES"];
            table.Rows[rowIndex]["DeliveryYN"] = table.Rows[rowIndex]["DeliveryYN"].AsText() == "Y" ? "예" : "아니오";
        }
        table.Columns.Remove("BRANDNAME");
        table.Columns.Remove("GOODSOPTIONSUMMARYVALUES");
        string[] headerName = { "번호", "주문일자", "주문번호", "구매사", "부서명", "주문자", "주문자 아이디", "판매사", "주문유형", "1단", "2단", "3단", "상품코드", "주문상품정보",  "수량", "모델명", "내용량", "출하예정일", "배송완료일", "주문처리현황", "결제수단", "담당자", "MD 메모", "공급사", "공급사 상품코드", "공급사2", "공급사 상품코드2", "매입단가\n(VAT포함)", "판매사단가\n(VAT포함)", "소셜공감 매출이익", "구매사단가\n(VAT포함)", "판매사 매출이익", "매입금액합계\n(VAT포함)", "판매사금액합계\n(VAT포함)","구매사금액합계\n(VAT포함)", "총 소셜공감매출", "배송비 발생유무" };
        var fileName = Server.UrlEncode(AdminId + "_주문내역");
        ExportExcel(fileName, headerName, table);
    }

    #region << 택배 업로드용 엑셀 저장 >>
    protected void btnDeliveryExport_Click(object sender, EventArgs e)
    {
        this.txtSearchSdate.Text = Request[this.txtSearchSdate.UniqueID];
        this.txtSearchEdate.Text = Request[this.txtSearchEdate.UniqueID];

        string sDate = Regex.Replace(this.txtSearchSdate.Text, @"-", "", RegexOptions.Singleline);
        string eDate = Regex.Replace(this.txtSearchEdate.Text, @"-", "", RegexOptions.Singleline);
        string searchDate = sDate + "-" + eDate;


        ExcelService excelService = new ExcelService();
        var param = new Dictionary<string, object> {
            { "nvar_P_STARTDATE", txtSearchSdate.Text.Trim()},
            { "nvar_P_ENDDATE", txtSearchEdate.Text.Trim()},
        };

        var table = excelService.GetAdminOrderDeliveryListExcel(param);
        
        string[] headerName = { "받으시는분","받으시는분전화","받는분담당자","받는분핸드폰","우편번호","총주소","수량","품목명","운임타입","지불조건","출고번호","특기사항" };
        var fileName = Server.UrlEncode(AdminId + "_택배업로드용_"+ searchDate);

        OrderDeliveryExportExcel(fileName, headerName, table);
    }

    public void OrderDeliveryExportExcel(string fileName, string[] headerNames, DataTable table)
    {

        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("택배업로드용");
            int headerIndex = 0;
            int colCount = 12;
            //Format the header
            using (ExcelRange rng = ws.Cells[1, 1, 1, colCount])
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

                ws.Cells[1, headerIndex+1].Value = name;
                headerIndex++;

            }

            if (table.Rows.Count > 0)
            {
                ws.Cells["A2"].LoadFromDataTable(table, false);

                //Format the data
                using (ExcelRange rng = ws.Cells[2, 1, table.Rows.Count + 1, colCount])
                {
                    rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

                }

                //셀 사이즈 오토 세팅
                using (ExcelRange rng = ws.Cells[2, 1, table.Rows.Count + 1, colCount])
                {
                    rng.AutoFitColumns();
                }
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