using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Goods;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using SocialWith.Biz.Excel;
using System.Data;
using System.Drawing;
using Urian.Core;
using System.Text.RegularExpressions;

public partial class Admin_SCMquote_newGoodsRequest : AdminPageBase
{
    protected GoodsService GoodsService = new GoodsService();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblAdmin.Text = UserInfoObject.Name;
        }
    }

    protected void ibtnSave_Click(object sender, EventArgs e)
    {
        string svidUser = Svid_User;
        string reqNo = hfReqNo.Value.Trim();
        string flag = ddlStatus.SelectedValue;

        var paramList = new Dictionary<string, object> {
            {"nvar_P_NEWGOODSREQNO", reqNo},
            {"nvar_P_SVID_USER", svidUser},
            {"char_P_FLAG", flag},
        };

        
        GoodsService.UpdateNewGoodReqStatus(paramList);
        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('저장되었습니다.');</script>");
    }


    public void ExportExcel(string fileName, string[] headerNames, DataTable table)
    {


        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("신규견적요청");
            int headerIndex = 0;
            int colCount = 17; //15열
            //Format the header
            using (ExcelRange rng = ws.Cells[5, 1, 5, colCount]) //제목 
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
                rng.Value = "  신규견적요청 (" + txtSearchSdate.Text.Trim() + " ~ " + txtSearchEdate.Text.Trim() + ")";
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

                ws.Cells[6, 15, table.Rows.Count + 5, 15].Style.Numberformat.Format = "yyyy-MM-dd";
                ws.Cells[6, 11, table.Rows.Count + 5, 11].Style.WrapText = true; // 품목상세설명
                ws.Cells[6, 12, table.Rows.Count + 5, 12].Style.WrapText = true; // 요청사항
                
                ws.Cells[5, 9, 5, 9].Style.WrapText = true; // 헤더 줄바꿈
                ws.Cells[5, 11, 5, 11].Style.WrapText = true;
                ws.Cells[5, 16, 5, 16].Style.WrapText = true; 

                ws.Cells[6, 9, table.Rows.Count + 5, 9].Style.Numberformat.Format = "#,###0개";
                ws.Cells[6, 10, table.Rows.Count + 5, 10].Style.Numberformat.Format = "#,###0원";

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


                //품목 상세설명 Cell Width세팅(Wraptext가 true로 설정되있으면 AutoFitColumns이 안먹는다...)
                ExcelRange columnCells1 = ws.Cells[6, 11, table.Rows.Count + 5, 11];
                columnCells1.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                ws.Column(9).Width = 15; //예상구매수량

                int maxLength1 = columnCells1.Max(cell => string.IsNullOrWhiteSpace(cell.Value.AsText()) ? 0 : cell.Value.ToString().Count(c => char.IsLetterOrDigit(c)));
                ws.Column(11).Width = maxLength1 + 20; // 품목 상세설명

                
                ExcelRange columnCells2 = ws.Cells[6, 12, table.Rows.Count + 5, 12];
                columnCells2.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                //null과 ""체크
                int maxLength2 = columnCells2.Max(cell => string.IsNullOrWhiteSpace(cell.Value.AsText()) ? 0 : cell.Value.ToString().Count(c => char.IsLetterOrDigit(c)));
                ws.Column(12).Width = maxLength2 + 20;

              

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
        
            this.txtSearchSdate.Text = Request[this.txtSearchSdate.UniqueID];
            this.txtSearchEdate.Text = Request[this.txtSearchEdate.UniqueID];

            ExcelService excelService = new ExcelService();
            var param = new Dictionary<string, object> {
            
            { "nvar_P_TODATEB", txtSearchSdate.Text.Trim()},
            { "nvar_P_TODATEE", txtSearchEdate.Text.Trim()},
        };

            var table = excelService.GetAdminSCMquoteExcel(param);
            
            string[] headerName = { "요청번호", "카테고리", "상품명", "규격", "제조사", "모델명", "원산지", "단위", "예상\n구매수량", "기존단가", "품목\n상세설명", "요청사항", "신청자","구매사", "신청일", "처리\n담당자", "진행현황"};
            var fileName = Server.UrlEncode(AdminId + "_신규견적요청");
            ExportExcel(fileName, headerName, table);
        
    }
}