using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using SocialWith.Biz.Excel;
using SocialWith.Biz.Goods;
using System.Drawing;
using System.Data;

public partial class Admin_Goods_SupplierMain : AdminPageBase
{
    //  protected SocialWith.Biz.Comapny.CompanyService CompanyService = new SocialWith.Biz.Comapny.CompanyService();
    GoodsService GoodsService = new GoodsService();
    protected string Ucode;
    string companycode;
    string tellno;
    string phoneno;
    string faxno;
    string email;
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        if (IsPostBack == false)
        {
            OrderEndListBind();
        }
    }

    protected void ParseRequestParameters()
    {
        Ucode = Request.QueryString["ucode"].ToString();
    }
    protected void OrderEndListBind(int page = 1)
    {

        var paramList = new Dictionary<string, object>{
           {"nume_P_PAGENO", page}
         , {"nume_P_PAGESIZE", 20}
         , {"nvar_P_SEARCHKEYWORD", txtSerch.Text.Trim() }
         , {"nvar_P_SEARCHTARGET",ddlSearchTarget.SelectedValue }

        };
        SocialWith.Biz.Comapny.CompanyService CompanyService = new SocialWith.Biz.Comapny.CompanyService();
        var list = CompanyService.GetSupplierList(paramList);
        int listCount = 0;


        if ((list != null) && (list.Count > 0))
        {
            listCount = list.FirstOrDefault().TotalCount;

        }


        ucListPager.TotalRecordCount = listCount;

        lvMemberListB.DataSource = list;
        lvMemberListB.DataBind();

    }


    protected void ucListPager_PageIndexChange(object sender)
    {
        OrderEndListBind(ucListPager.CurrentPageIndex);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        OrderEndListBind();
    }


    protected int Calculate(int a, int b)
    {

        int returnVal = (a * b);
        return returnVal;
    }


    protected void btnSave_Click(object sender, EventArgs e)
    {
        this.ComCodeNo.Text = Request[this.ComCodeNo.UniqueID];  //업체코드
        this.txtComName.Text = Request[this.txtComName.UniqueID];  //업체명

        this.lblFirstNum.Text = Request[this.lblFirstNum.UniqueID];
        this.lblMiddleNum.Text = Request[this.lblMiddleNum.UniqueID];
        this.lblLastNum.Text = Request[this.txtComName.UniqueID];

        if (ddlTelPhone.Text == "")
        {
            tellno = ((string.IsNullOrWhiteSpace(lblMiddleNumber.Text) && string.IsNullOrWhiteSpace(lblLastNumber.Text)) == true ? "" : lblMiddleNumber.Text + "-" + lblLastNumber.Text);
           
        }

        else
        {
            tellno = ((string.IsNullOrWhiteSpace(lblMiddleNumber.Text) && string.IsNullOrWhiteSpace(lblLastNumber.Text)) == true ? "" : ddlTelPhone.Text + "-" + lblMiddleNumber.Text + "-" + lblLastNumber.Text);
        }

        phoneno = ((string.IsNullOrWhiteSpace(txtSelPhone2.Text) && string.IsNullOrWhiteSpace(txtSelPhone3.Text)) == true ? "" : ddlSelPhone.Text + "-" + txtSelPhone2.Text + "-" + txtSelPhone3.Text);
        faxno = ((string.IsNullOrWhiteSpace(lblMiddleFax.Text) && string.IsNullOrWhiteSpace(lblLastFax.Text)) == true ? "" : ddlFax.Text + "-" + lblMiddleFax.Text + "-" + lblLastFax.Text);
        email = ((string.IsNullOrWhiteSpace(txtFirstEmail.Text) && string.IsNullOrWhiteSpace(txtLastEmail.Text)) == true ? "" : txtFirstEmail.Text + "@" + txtLastEmail.Text);
        companycode = lblFirstNum.Text + lblMiddleNum.Text + lblLastNum.Text;
        string txtPostalCode = Request[this.txtPostalCode.UniqueID];
        string txtBankName = Request[this.txtBankName.UniqueID];
        string txtBankNo = Request[this.txtBankNo.UniqueID];
        string txtSupplyBankName = Request[this.txtSupplyBankName.UniqueID];


        this.SupplyDate.Text = Request[this.SupplyDate.UniqueID];
        this.txtAddress1.Text = Request[this.txtAddress1.UniqueID];
        this.txtAddress2.Text = Request[this.txtAddress2.UniqueID];

        var paramList = new Dictionary<string, object>
        {
           { "nvar_P_SUPPLYCOMPANYCODE", ComCodeNo.Text.Trim() },
           {"nvar_P_SUPPLYCOMPANYNAME",txtComName.Text.Trim() },
           {"nvar_P_SUPPLYCOMPANY_NO",companycode.Trim() },
           {"nvar_P_SUPPLYCOMPANYDELEGATE_NAME",lblName.Text.Trim() },
           {"nvar_P_TELNO",tellno.Trim() },
           {"nvar_P_PHONENO",phoneno.Trim() },
           {"nvar_P_FAXNO",faxno.Trim() },
           {"nvar_P_EMAIL",email.Trim() },
           {"char_P_ZIPCODE",txtPostalCode.Trim() },
           {"nvar_P_ADDRESS_1",txtAddress1.Text.Trim() },
           {"nvar_P_ADDRESS_2",txtAddress2.Text.Trim() },
           {"nvar_P_NAME",txtPerson.Text.Trim() },
           {"nvar_P_DEPTNAME",lblDept.Text.Trim() },
           {"nvar_P_SUPPLYDATE", String.Format("{0:yyyy-MM-dd}",  SupplyDate.Text)},
           {"nvar_P_PAYDATE", PayDate.Text.Trim()},        //결제일자( DD )
           {"nvar_P_SUPPLYCATEGORY",categoryCode.Value.Trim()},                  //카테고리명
           {"nvar_P_ADMINUSERID",hfAdmUserId.Value.Trim()},    //소셜위드담당자코드
           {"nvar_P_ADMINUSERNAME",hfAdmUserNm.Value.Trim()},      //소셜위드담당자명
           {"nvar_P_BANKNAME", txtBankName.Trim()},    //은행명
           {"nvar_ P_BANKNO", txtBankNo.Trim()}, //계좌번호
           {"nvar_P_SUPPLYBANKNAME", txtSupplyBankName.Trim()}  //예금주명

        };
        GoodsService.UpdateCompany(paramList);

        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('공급사 정보가 수정되었습니다.');</script>");
        Response.Redirect(string.Format("SupplierMain.aspx?ucode="+Ucode)); //메인으로 가기.
    }

    public void ExportExcel(string fileName, string[] headerNames, DataTable table)
    {
        using(ExcelPackage pck = new ExcelPackage())
        {
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("공급업체조회");
            int headerIndex = 0;
            int colCount = 15;
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

            foreach(string name in headerNames)
            {
                ws.Cells[5, headerIndex + 1].Value = name;
                headerIndex++;
            }

            using(ExcelRange rng = ws.Cells[2, 1, 3, colCount])
            {
                rng.Value = "  공급업체조회 ";
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
                ws.Cells["A6"].LoadFromDataTable(table, false);

                ws.Cells[6, 14, table.Rows.Count + 5, 14].Style.WrapText = true;
                ws.Cells[6, 2, table.Rows.Count + 5, 2].Style.Numberformat.Format = "yyyy-MM-dd";
                ws.Cells[6, 15, table.Rows.Count + 5, 15].Style.Numberformat.Format = "yyyy-MM-dd";

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
                ExcelRange columnCells = ws.Cells[6, 14, table.Rows.Count + 5, 14];
                int maxLength = columnCells.Max(cell => cell.Value.ToString().Count(c => char.IsLetterOrDigit(c)));
                ws.Column(14).Width = maxLength + 20; // 2 is just an extra buffer for all that is not letter/digits.

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
        ExcelService excelService = new ExcelService();
        var param = new Dictionary<string, object>
        {
            { "nvar_P_SEARCHKEYWORD", txtSerch.Text.Trim() },
            { "nvar_P_SEARCHTARGET", ddlSearchTarget.SelectedValue }
        };

        var table = excelService.GetSupplierListExcel(param);
        string[] headerName = { "번호", "거래등록일", "결제일자", "공급업체코드", "업체명", "사업자번호", "카테고리명", "대표자명", "업체담당자명", "전화번호", "FAX", "핸드폰", "이메일", "상세주소", "등록일" };
        var fileName = Server.UrlEncode(AdminId + "_공급업체 관리");
        ExportExcel(fileName, headerName, table);

    }
}