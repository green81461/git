using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Cart;
using SocialWith.Biz.Pay;
using Urian.Core;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.ComponentModel.DataAnnotations;
using System.Drawing;
using System.Reflection;
using System.Web.UI.HtmlControls;
using SocialWith.Biz.Excel;
using System.Data;
using System.Configuration;

public partial class Cart_CartList : PageBase
{
    CartService cartService = new CartService();
    PayService payService = new PayService();
    public string svidRole = string.Empty;
    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        cartCss.Text = string.Format("<link rel=\"stylesheet\" type=\"text/css\" href=\"{0}\"></script>", "../Content/Cart/cart.css?dt=" + DateTime.Now.ToString("yyyyMMddhhmmss"));
        popupCss.Text = string.Format("<link rel=\"stylesheet\" type=\"text/css\" href=\"{0}\"></script>", "../Content/popup.css?dt=" + DateTime.Now.ToString("yyyyMMddhhmmss"));
        //권한 설정
        svidRole = UserInfoObject.Svid_Role;
        if (IsPostBack == false)
        {
            DefaultDataBind();
        }
    }

    #region <<데이터바인드>>
    protected void DefaultDataBind()
    {
        //리스트 받아오는거..
        GetPayStatus();
        string compcode = string.Empty;
        string saleCompCode = string.Empty;
        string freeCompYN = string.Empty;
        if (UserInfoObject != null && UserInfoObject.UserInfo != null)
        {
            compcode = !string.IsNullOrWhiteSpace(UserInfoObject.UserInfo.PriceCompCode) ? UserInfoObject.UserInfo.PriceCompCode : "EMPTY"; 
            saleCompCode = !string.IsNullOrWhiteSpace(UserInfoObject.UserInfo.SaleCompCode) ? UserInfoObject.UserInfo.SaleCompCode: "EMPTY" ;
            freeCompYN = UserInfoObject.UserInfo.FreeCompanyYN;
        }
        var paramList = new Dictionary<string, object> {           
            {"nvar_P_SVID_USER", Svid_User }, 
            {"nvar_P_DELFLAG", "N"},
            {"nvar_P_COMPCODE", compcode},
            {"nvar_P_SALECOMPCODE", saleCompCode},
            {"nvar_P_BDONGSHINCHECK", UserInfoObject.UserInfo.BmroCheck.AsText("N")},
            {"nvar_P_FREECOMPANYYN", freeCompYN},
           
        };

        var list = cartService.CartList(paramList);
        
        rptCart.DataSource = list;
        rptCart.DataBind();
    }

    protected void GetPayStatus()
    {

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", Svid_User },
        };

        var info = payService.GetCurrentPayStatus(paramList);
        var value = string.Empty;
        if (!string.IsNullOrWhiteSpace(info))
        {
            value = info.AsDecimal().ToString("N0");
        }
        else
        {
            value = "0";
        }
        lblPayStatus.Text = DateTime.Now.Month + "월 총 주문금액(VAT포함) : " + value + "원";
    }
    
    protected void rptCart_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {

        if (rptCart.Items.Count == 0)
        {
            if (e.Item.ItemType == ListItemType.Footer)
            {
                HtmlTableRow lblFooter = (HtmlTableRow)e.Item.FindControl("trEmpty");

                lblFooter.Visible = true;

                //e.Item.FindControl("trEmpty").Visible = true;
            }
        }

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            //면세상품이면 글자 출력
            var taxYn = ((HiddenField)e.Item.FindControl("hfGdsTax")).Value.AsText();
            if (taxYn.Equals("2"))
                e.Item.FindControl("lblTax").Visible = true;

            var hfDcPrice = ((HiddenField)e.Item.FindControl("hfDcPrice")).Value.AsText();
            var tdOriginPrice = (HtmlTableCell)e.Item.FindControl("tdOriginPrice");
            var tdDcPrice = (HtmlTableCell)e.Item.FindControl("tdDcPrice");
            var hfCompanyGoodsYN = ((HiddenField)e.Item.FindControl("hfCompanyGoodsYN"));
            var hfGoodsDisplayReason = ((HiddenField)e.Item.FindControl("hfGoodsDisplayReason"));
            var cbCart = ((HtmlInputCheckBox)e.Item.FindControl("cbCart"));
            var hfQty = ((HiddenField)e.Item.FindControl("hfQty"));
            var hfMoq = ((HiddenField)e.Item.FindControl("hfMoq"));
            var trCart = (HtmlTableRow)e.Item.FindControl("trCart");

            if (hfQty != null && hfMoq != null && trCart != null)
            {
                if (hfQty.Value.AsInt() % hfMoq.Value.AsInt() != 0)
                {
                    trCart.Attributes.Add("style", "background-color:#fee0e1");
                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('장바구니에 최소구매수량 단위가 변경된 상품이 있습니다. 해당 상품을 삭제하시고 다시 장바구니에 담아주세요.');</script>");
                }
            }
            if (tdOriginPrice != null && tdDcPrice != null)
            {
                if (!string.IsNullOrWhiteSpace(hfDcPrice))
                {
                    tdOriginPrice.Visible = false;
                    tdDcPrice.Visible = true;
                }
                else
                {
                    tdOriginPrice.Visible = true;
                    tdDcPrice.Visible = false;
                }
            }

            if (hfCompanyGoodsYN != null && hfGoodsDisplayReason !=null && cbCart != null)
            {
                if (!string.IsNullOrWhiteSpace(hfGoodsDisplayReason.Value.AsText()) || hfCompanyGoodsYN.Value.AsText() == "N")
                {
                    cbCart.Disabled = true;
                }
            }
        }

    }
    protected decimal Calculate(int a, int b, decimal? c) {
        decimal returnVal = 0;
        if (c != null)
        {
            returnVal = b.AsDecimal() * c.AsDecimal();
        }
        else
        {
            returnVal = a.AsDecimal() * b.AsDecimal();
        }
        
        return returnVal;
    }

    protected string SetGoodsDisplayText(string goodsYN, string reason)
    {
        string returnVal = string.Empty;
        if (goodsYN == "N")
        {
            returnVal = "(판매 개시전)";
        }
        else if (goodsYN == "Y")
        {
            if (!string.IsNullOrWhiteSpace(reason))
            {
                returnVal = "(" + reason + ")";
            }
        }
        return returnVal;
    }
    #endregion

    #region << 엑셀 파일 저장 >>
    

    public void ExportExcel(string fileName, string[] headerNames, DataTable table, string type)
    {


        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("장바구니 내역");
            int range = 0;
            int goodsPriceCellIndex = 0;
            int goodsTotalPriceCellIndex = 0;

            //Format the Title
            using (ExcelRange rng = ws.Cells[2, 1, 3, 10])
            {
                rng.Value = "장바구니 내역";
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

            if (type == "A")
            {
                range = 10;
                goodsPriceCellIndex = 8;
                goodsTotalPriceCellIndex = 10;
            }
            else
            {
                range = 12;
                goodsPriceCellIndex = 10;
                goodsTotalPriceCellIndex = 12;
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
                ws.Cells["A6"].LoadFromDataTable(table, false);

                ws.Cells[6, 3, table.Rows.Count + 5, 3].Style.WrapText = true;
                ws.Cells[6, goodsPriceCellIndex, table.Rows.Count + 5, goodsPriceCellIndex].Style.Numberformat.Format = "#,###원";
                ws.Cells[6, goodsTotalPriceCellIndex, table.Rows.Count + 5, goodsTotalPriceCellIndex].Style.Numberformat.Format = "#,###원";



                //Format the header
                using (ExcelRange rng = ws.Cells[5, 1, 5, range])
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
                using (ExcelRange rng = ws.Cells[6, 1, table.Rows.Count + 5, range])
                {
                    rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

                }
                //셀 사이즈 오토 세팅
                using (ExcelRange rng = ws.Cells[5, 1, table.Rows.Count + 5, range])
                {
                    rng.AutoFitColumns();
                }

                for (int i = 5; i <= table.Rows.Count + 4; i++)
                {
                    ws.Row(i + 1).Height = 36;
                }

                //상품정보 Cell Width세팅 (Wraptext가 true로 설정되있으면 AutoFitColumns이 안먹는다...)
                ExcelRange columnCells = ws.Cells[6, 3, table.Rows.Count + 5, 3];
                columnCells.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                int maxLength = columnCells.Max(cell => cell.Value.ToString().Count(c => char.IsLetterOrDigit(c)));
                ws.Column(3).Width = maxLength + 20; // 2 is just an extra buffer for all that is not letter/digits.
            }
            



            //Write it back to the client
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;  filename=" + fileName + ".xlsx");
            Response.BinaryWrite(pck.GetAsByteArray());
            Response.End();
        }
    }
    
    #endregion


    protected void btnExcelExport_Click(object sender, EventArgs e)
    {
        string unumCartNos = string.Empty;
        string compCode = string.Empty;
        string saleCompCode = string.Empty;
        string freeCompYN = string.Empty;
        if (UserInfoObject != null && UserInfoObject.UserInfo != null)
        {
            compCode = !string.IsNullOrWhiteSpace(UserInfoObject.UserInfo.PriceCompCode) ? UserInfoObject.UserInfo.PriceCompCode : "EMPTY";
            saleCompCode = !string.IsNullOrWhiteSpace(UserInfoObject.UserInfo.SaleCompCode) ? UserInfoObject.UserInfo.SaleCompCode : "EMPTY";
            freeCompYN = UserInfoObject.UserInfo.FreeCompanyYN;
        }

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", Svid_User},
            {"nvar_P_UNUM_CARTNOS", hfCartNos.Value},
            {"nvar_P_DELFLAG", "N"},
            {"nvar_P_COMPCODE", compCode},
            {"nvar_P_SALECOMPCODE", saleCompCode},
            {"nvar_P_BDONGSHINCHECK",  UserInfoObject.UserInfo.BmroCheck.AsText("N")},
            {"nvar_P_FREECOMPANYYN", freeCompYN},
        };

        ExcelService excelService = new ExcelService();
        var table = excelService.GetExcelCartList(paramList);
        for (int rowIndex = 0; rowIndex < table.Rows.Count; rowIndex++)
        {
            table.Rows[rowIndex]["GOODSFINALNAME"] = "[" + table.Rows[rowIndex]["BRANDNAME"] + "]" + table.Rows[rowIndex]["GOODSFINALNAME"] + "\n" + table.Rows[rowIndex]["GOODSOPTIONSUMMARYVALUES"];
            if (!string.IsNullOrWhiteSpace(table.Rows[rowIndex]["GOODSDCPRICEVAT"].AsText()))
            {
                table.Rows[rowIndex]["GOODSSALEPRICEVAT"] = table.Rows[rowIndex]["GOODSDCPRICEVAT"];
            }
        }
        table.Columns.Remove("BRANDNAME");
        table.Columns.Remove("GOODSOPTIONSUMMARYVALUES");
        table.Columns.Remove("GOODSDCPRICEVAT");
        table.Columns.Remove("COMPANYDEPT_NAME");
        var fileName = Server.UrlEncode(UserId + "_주문내역");
        string[] headerName = { "장바구니번호", "상품코드", "상품정보", "모델명", "최소수량", "내용량", "출하예정일", "상품가격", "수량", "합계금액" };
        ExportExcel(fileName, headerName, table, "A");

    }
}