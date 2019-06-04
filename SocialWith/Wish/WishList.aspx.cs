using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Cart;
using SocialWith.Biz.Order;
using SocialWith.Biz.Pay;
using SocialWith.Biz.Wish;
using Urian.Core;
using SocialWith.Data.Wish;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.ComponentModel.DataAnnotations;
using System.Drawing;
using System.Reflection;
using SocialWith.Biz.Excel;
using System.Data;
using System.Configuration;
using System.Web.UI.HtmlControls;

public partial class Wish_WishList : PageBase
{
    WishService WishService = new WishService();
    CartService cartService = new CartService();
    OrderService orderService = new OrderService();
    PayService payService = new PayService();
    protected string vatTag = "포함";
    string GroupCode = string.Empty;

    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();

        if (IsPostBack == false)
        {
            DefaultDataBind();
        }
    }

    protected void ParseRequestParameters()
    {
        GroupCode = Request.QueryString["GroupCode"].AsText();
    }

    #region <<데이터바인드>>
    protected void DefaultDataBind()
    {
        if (UserInfoObject.UserInfo.FreeCompanyVATYN.AsText("N") == "N")
        {
            vatTag = "별도";
        }

        if (UserInfoObject.Svid_Role == "A1")
        {
            if (UserInfoObject.UserInfo.BPestimateCompareYN.AsText("N") == "N")
            {
                btnOrder.Visible = true;
            }
            
            btnCartAdd.Visible = true;
        }
        else
        {
            btnCartAdd.Visible = true;
        }
        GetWishInfoList();
        if (string.IsNullOrWhiteSpace(GroupCode))
        {
            GroupCode = ddlWishInfo.SelectedValue;
        }
        else
        {
            ddlWishInfo.SelectedValue = GroupCode;
        }
        GetWishList();
        GetWishGroupList();
        GetPayStatus();

    }

    protected void GetWishList(int page = 1)
    {
        string compCode = string.Empty;
        string saleCompCode = string.Empty;
        string freeCompYN = string.Empty;
        string freeCompVatYN = string.Empty;
        if (UserInfoObject != null && UserInfoObject.UserInfo != null)
        {
            compCode = !string.IsNullOrWhiteSpace(UserInfoObject.UserInfo.PriceCompCode) ? UserInfoObject.UserInfo.PriceCompCode : "EMPTY" ;
            saleCompCode = !string.IsNullOrWhiteSpace(UserInfoObject.UserInfo.SaleCompCode) ? UserInfoObject.UserInfo.SaleCompCode : "EMPTY";
            freeCompYN = UserInfoObject.UserInfo.FreeCompanyYN;
            freeCompVatYN = UserInfoObject.UserInfo.FreeCompanyVATYN.AsText("N");
        }
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", Svid_User },
            {"nvar_P_UNUM_WISHLISTGROUP", ddlWishInfo.SelectedValue},
            {"nvar_P_COMPCODE", compCode},
            {"nvar_P_SALECOMPCODE", saleCompCode},
            {"nvar_P_BDONGSHINCHECK",  UserInfoObject.UserInfo.BmroCheck.AsText("N")},
            {"nvar_P_FREECOMPANYYN", freeCompYN },
            {"nvar_P_FREECOMPANYVATYN", freeCompVatYN},
            {"inte_P_PAGENO", page },
            {"inte_P_PAGESIZE", 20 },

        };
        var list = WishService.GetWishList(paramList);
        
        int listCount = 0;
        if (list != null)
        {
            if (list.Count > 0)
            {
                listCount = list.FirstOrDefault().TotalCount;

            }
            ucListPager.TotalRecordCount = listCount;


        }
        lvWishList.DataSource = list;
        lvWishList.DataBind();
    }

    protected void GetWishGroupList()
    {

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", Svid_User },
        };


        List<WishGroupDTO> list = WishService.GetListByWishGroup(paramList);

        lvPopupList.DataSource = list;
        lvPopupList.DataBind();
    }

    protected void GetWishInfoList()
    {
        ddlWishInfo.Items.Clear();
        ddlWishInfo.Items.Add(new ListItem("---전체---", ""));
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", Svid_User },
        };


        var list = WishService.GetWishInfoList(paramList);

        if (list != null)
        {
            if (list.Count > 0)
            {
                foreach (var item in list)
                {
                    ddlWishInfo.Items.Add(new ListItem(item.WishListGroupName, item.UNum_WishListGroup.AsText()));
                }
            }
        }
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
            value = info.AsDecimal().ToString("#,###");
        }
        else
        {
            value = "0";
        }
        lblPayStatus.Text = DateTime.Now.Month + "월 총 주문금액(VAT포함) : " + value + "원";
    }

    protected string SetGoodsDisplayText(string goodsYN, string reason) {
        string returnVal = string.Empty;
        if (goodsYN == "N")
        {
            returnVal = "(판매 개시전)";
        }
        else if(goodsYN == "Y")
        {
            if (!string.IsNullOrWhiteSpace(reason))
            {
                returnVal = "("+ reason + ")";
            }
        }
        return returnVal;
    }
    #endregion

    protected void ucListPager_PageIndexChange(object sender)
    {

        GetWishList(ucListPager.CurrentPageIndex);
    }


    //protected void btnAddGroup_Click(object sender, ImageClickEventArgs e)
    //{
    //    foreach (ListViewItem item in lvWishList.Items)
    //    {
    //        CheckBox chSelect = (CheckBox)item.FindControl("chSelect");
    //        HiddenField hfWishNum = (HiddenField)item.FindControl("hfWishNum");
    //        HiddenField hfCategoryCode = (HiddenField)item.FindControl("hfCategoryCode");


    //        if (chSelect.Checked)
    //        {
    //            var paramList = new Dictionary<string, object> {
    //                     { "nume_P_UNUM_WISHLISTGROUP",hfWishGroupSeq.Value.Trim()}
    //                    ,{ "nume_P_UNUM_WISHLIST",hfWishNum.Value.Trim()}
    //                    ,{ "nvar_P_SVID_USER",Svid_User}
    //                    ,{ "nvar_P_GOODSFINALCATEGORYCODE",hfCategoryCode.Value.Trim()}

    //                    };

    //            WishService.SaveWishListInfo(paramList);
    //        }
    //    }
    //    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('등록되었습니다.');</script>");
    //    GetWishInfoList();
    //    GetWishList();
    //    GetWishGroupList();
    //}

    //protected void btnWishDel_Click(object sender, ImageClickEventArgs e)
    //{
    //    foreach (ListViewItem item in lvWishList.Items)
    //    {
    //        CheckBox chSelect = (CheckBox)item.FindControl("chSelect");
    //        HiddenField hfWishNum = (HiddenField)item.FindControl("hfWishNum");
    //        HiddenField hfCategoryCode = (HiddenField)item.FindControl("hfCategoryCode");


    //        if (chSelect.Checked)
    //        {
    //            var paramList = new Dictionary<string, object> {
    //                     { "nume_P_UNUM_WISHLIST",hfWishNum.Value.Trim()},
    //                      { "nvar_P_UNUM_WISHLISTGROUP",ddlWishInfo.SelectedValue}
    //                    };

    //            WishService.DeleteWishList(paramList);
    //        }
    //    }
    //    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('삭제되었습니다.');</script>");
    //    GetWishList();
    //}

    //드롭다운리스트 검색
    protected void ddlWishInfo_SelectedIndexChanged(object sender, EventArgs e)
    {
        GetWishList(1);
        ucListPager.CurrentPageIndex = 1;
    }

    //protected void btnWishExcel_Click(object sender, ImageClickEventArgs e)
    //{
    //    string compCode = string.Empty;
    //    string saleCompCode = string.Empty;
    //    string freeCompYN = string.Empty;
    //    string freeCompVatYN = string.Empty;
    //    if (UserInfoObject != null && UserInfoObject.UserInfo != null)
    //    {
    //        compCode = !string.IsNullOrWhiteSpace(UserInfoObject.UserInfo.PriceCompCode) ? UserInfoObject.UserInfo.PriceCompCode : "EMPTY";
    //        saleCompCode = !string.IsNullOrWhiteSpace(UserInfoObject.UserInfo.SaleCompCode) ? UserInfoObject.UserInfo.SaleCompCode : "EMPTY";
    //        freeCompYN = UserInfoObject.UserInfo.FreeCompanyYN;
    //        freeCompVatYN = UserInfoObject.UserInfo.FreeCompanyVATYN.AsText("N");
    //    }

    //    var paramList = new Dictionary<string, object> {
    //        {"nvar_P_SVID_USER", Svid_User },
    //        {"nvar_P_UNUM_WISHLISTGROUP", ddlWishInfo.SelectedValue.Trim()},
    //        {"nvar_P_COMPCODE", compCode},
    //        {"nvar_P_SALECOMPCODE", saleCompCode},
    //        {"nvar_P_BDONGSHINCHECK",  UserInfoObject.UserInfo.BdongshinCheck.AsText("N")},
    //        {"nvar_P_FREECOMPANYYN", freeCompYN },
    //        {"nvar_P_FREECOMPANYVATYN", freeCompVatYN},
            

    //    };
    //    ExcelService excelService = new ExcelService();
       
    //    var table = excelService.GetExcelWishList(paramList);
    //    for (int rowIndex = 0; rowIndex < table.Rows.Count; rowIndex++)
    //    {
    //        table.Rows[rowIndex]["GOODSFINALNAME"] = "[" + table.Rows[rowIndex]["BRANDNAME"] + "]" + table.Rows[rowIndex]["GOODSFINALNAME"] + "\n" + table.Rows[rowIndex]["GOODSOPTIONSUMMARYVALUES"];
    //        if (!string.IsNullOrWhiteSpace(table.Rows[rowIndex]["GOODSDCPRICEVAT"].AsText()))
    //        {
    //            table.Rows[rowIndex]["GOODSSALEPRICEVAT"] = table.Rows[rowIndex]["GOODSDCPRICEVAT"];
    //        }
    //    }
    //    table.Columns.Remove("ENTRYDATE");
    //    table.Columns.Remove("BRANDNAME");
    //    table.Columns.Remove("GOODSOPTIONSUMMARYVALUES");
    //    table.Columns.Remove("GOODSUNIT");
    //    table.Columns.Remove("GOODSUNITQTY");
    //    table.Columns.Remove("GOODSSUBUNIT");
    //    table.Columns.Remove("GOODSUNITSUBQTY");
    //    table.Columns.Remove("GOODSDCPRICEVAT");
    //    table.Columns.Add("QTY", typeof(int));
    //    table.Columns.Add("GOODSTOTALSALEPRICEVAT", typeof(decimal));

    //    string[] headerName = { "상품코드", "상품정보",  "모델명","출하예정일", "최소수량", "내용량", "상품가격(VAT "+vatTag+")", "수량", "총금액(VAT " + vatTag + ")" };
    //    if (table.Rows.Count > 0)
    //    {
    //        for (int i = 0; i < table.Rows.Count; i++)
    //        {
    //            foreach (ListViewItem item in lvWishList.Items)
    //            {
    //                TextBox txtQty = (TextBox)item.FindControl("txtQty");
    //                HiddenField hfGoodsCode = (HiddenField)item.FindControl("hfGoodsCode");

    //                if (table.Rows[i]["GOODSCODE"].Equals(hfGoodsCode.Value.Trim()))
    //                {
    //                    table.Rows[i]["QTY"] = Int32.Parse(txtQty.Text.Trim());

    //                    var gdsSalePriceVat = table.Rows[i]["GOODSSALEPRICEVAT"].AsDecimal();
    //                    var totPriceVat = gdsSalePriceVat * table.Rows[i]["QTY"].AsDecimal();
    //                    table.Rows[i]["GOODSTOTALSALEPRICEVAT"] = totPriceVat.AsDecimal();
    //                }
    //            }
    //        }
    //    }

    //    var fileName = Server.UrlEncode(UserId + "_관심상품");
    //    ExportExcel(fileName, headerName, table);
    //}




    public void ExportExcel(string fileName, string[] headerNames, DataTable table)
    {


        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("관심상품보관함");
            
            int headerIndex = 0;
            int colCount = 9;
            foreach (string name in headerNames)
            {

                ws.Cells[5, headerIndex + 1].Value = name;
                headerIndex++;

            }
            //Format the Title
            using (ExcelRange rng = ws.Cells[2, 1, 3, colCount])
            {
                rng.Value = "관심상품보관함";
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

            //populate our Data
            if (table.Rows.Count > 0)
            {
                ws.Cells["A6"].LoadFromDataTable(table,false);

                ws.Cells[6, 2, table.Rows.Count + 5, 2].Style.WrapText = true;
                ws.Cells[6, 7, table.Rows.Count + 5, 7].Style.Numberformat.Format = "#,###0원";
                ws.Cells[6, 9, table.Rows.Count + 5, 9].Style.Numberformat.Format = "#,###0원";



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

                for (int i = 5; i <= table.Rows.Count+4; i++)
                {
                    ws.Row(i + 1).Height = 36;
                }

                //상품정보 Cell Width세팅(Wraptext가 true로 설정되있으면 AutoFitColumns이 안먹는다...)
                ExcelRange columnCells = ws.Cells[6, 2, table.Rows.Count + 5, 2];
                columnCells.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                int maxLength = columnCells.Max(cell => cell.Value.ToString().Count(c => char.IsLetterOrDigit(c)));
                ws.Column(2).Width = maxLength + 20; // 2 is just an extra buffer for all that is not letter/digits.
            }
            
            //Write it back to the client
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;  filename=" + fileName + ".xlsx");
            Response.BinaryWrite(pck.GetAsByteArray());
            Response.End();
        }
    }

    



    protected void lvWishList_ItemDataBound(object sender, ListViewItemEventArgs e)
    {
        if (e.Item.ItemType == ListViewItemType.DataItem)
        {
            //면세상품이면 글자 출력
            var taxYn = ((HiddenField)e.Item.FindControl("hfGdsTax")).Value.AsText();
            if (taxYn.Equals("2"))
                e.Item.FindControl("lblTax").Visible = true;


            var hfDcPrice = ((HiddenField)e.Item.FindControl("hfDcPrice")).Value.AsText();
            var tdOriginPrice = (HtmlTableCell)e.Item.FindControl("tdOriginPrice");
            var tdDcPrice = (HtmlTableCell)e.Item.FindControl("tdDcPrice");

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
            
        }

    }

    protected void btnWishDel_Click(object sender, EventArgs e)
    {
        foreach (ListViewItem item in lvWishList.Items)
        {
            CheckBox chSelect = (CheckBox)item.FindControl("chSelect");
            HiddenField hfWishNum = (HiddenField)item.FindControl("hfWishNum");
            HiddenField hfCategoryCode = (HiddenField)item.FindControl("hfCategoryCode");


            if (chSelect.Checked)
            {
                var paramList = new Dictionary<string, object> {
                         { "nume_P_UNUM_WISHLIST",hfWishNum.Value.Trim()},
                          { "nvar_P_UNUM_WISHLISTGROUP",ddlWishInfo.SelectedValue}
                        };

                WishService.DeleteWishList(paramList);
            }
        }
        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('삭제되었습니다.');</script>");
        GetWishList();
    }

    protected void btnWishExcel_Click(object sender, EventArgs e)
    {
        string compCode = string.Empty;
        string saleCompCode = string.Empty;
        string freeCompYN = string.Empty;
        string freeCompVatYN = string.Empty;
        if (UserInfoObject != null && UserInfoObject.UserInfo != null)
        {
            compCode = !string.IsNullOrWhiteSpace(UserInfoObject.UserInfo.PriceCompCode) ? UserInfoObject.UserInfo.PriceCompCode : "EMPTY";
            saleCompCode = !string.IsNullOrWhiteSpace(UserInfoObject.UserInfo.SaleCompCode) ? UserInfoObject.UserInfo.SaleCompCode : "EMPTY";
            freeCompYN = UserInfoObject.UserInfo.FreeCompanyYN;
            freeCompVatYN = UserInfoObject.UserInfo.FreeCompanyVATYN.AsText("N");
        }

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", Svid_User },
            {"nvar_P_UNUM_WISHLISTGROUP", ddlWishInfo.SelectedValue.Trim()},
            {"nvar_P_COMPCODE", compCode},
            {"nvar_P_SALECOMPCODE", saleCompCode},
            {"nvar_P_BDONGSHINCHECK",  UserInfoObject.UserInfo.BmroCheck.AsText("N")},
            {"nvar_P_FREECOMPANYYN", freeCompYN },
            {"nvar_P_FREECOMPANYVATYN", freeCompVatYN},


        };
        ExcelService excelService = new ExcelService();

        var table = excelService.GetExcelWishList(paramList);
        for (int rowIndex = 0; rowIndex < table.Rows.Count; rowIndex++)
        {
            table.Rows[rowIndex]["GOODSFINALNAME"] = "[" + table.Rows[rowIndex]["BRANDNAME"] + "]" + table.Rows[rowIndex]["GOODSFINALNAME"] + "\n" + table.Rows[rowIndex]["GOODSOPTIONSUMMARYVALUES"];
            if (!string.IsNullOrWhiteSpace(table.Rows[rowIndex]["GOODSDCPRICEVAT"].AsText()))
            {
                table.Rows[rowIndex]["GOODSSALEPRICEVAT"] = table.Rows[rowIndex]["GOODSDCPRICEVAT"];
            }
        }
        table.Columns.Remove("ENTRYDATE");
        table.Columns.Remove("BRANDNAME");
        table.Columns.Remove("GOODSOPTIONSUMMARYVALUES");
        table.Columns.Remove("GOODSUNIT");
        table.Columns.Remove("GOODSUNITQTY");
        table.Columns.Remove("GOODSSUBUNIT");
        table.Columns.Remove("GOODSUNITSUBQTY");
        table.Columns.Remove("GOODSDCPRICEVAT");
        table.Columns.Add("QTY", typeof(int));
        table.Columns.Add("GOODSTOTALSALEPRICEVAT", typeof(decimal));

        string[] headerName = { "상품코드", "상품정보", "모델명", "출하예정일", "최소수량", "내용량", "상품가격(VAT " + vatTag + ")", "수량", "총금액(VAT " + vatTag + ")" };
        if (table.Rows.Count > 0)
        {
            for (int i = 0; i < table.Rows.Count; i++)
            {
                foreach (ListViewItem item in lvWishList.Items)
                {
                    TextBox txtQty = (TextBox)item.FindControl("txtQty");
                    HiddenField hfGoodsCode = (HiddenField)item.FindControl("hfGoodsCode");

                    if (table.Rows[i]["GOODSCODE"].Equals(hfGoodsCode.Value.Trim()))
                    {
                        table.Rows[i]["QTY"] = Int32.Parse(txtQty.Text.Trim());

                        var gdsSalePriceVat = table.Rows[i]["GOODSSALEPRICEVAT"].AsDecimal();
                        var totPriceVat = gdsSalePriceVat * table.Rows[i]["QTY"].AsDecimal();
                        table.Rows[i]["GOODSTOTALSALEPRICEVAT"] = totPriceVat.AsDecimal();
                    }
                }
            }
        }

        var fileName = Server.UrlEncode(UserId + "_관심상품");
        ExportExcel(fileName, headerName, table);
    }

   

    protected void btnAddGroup_Click(object sender, EventArgs e)
    {
        foreach (ListViewItem item in lvWishList.Items)
        {
            CheckBox chSelect = (CheckBox)item.FindControl("chSelect");
            HiddenField hfWishNum = (HiddenField)item.FindControl("hfWishNum");
            HiddenField hfCategoryCode = (HiddenField)item.FindControl("hfCategoryCode");


            if (chSelect.Checked)
            {
                var paramList = new Dictionary<string, object> {
                         { "nume_P_UNUM_WISHLISTGROUP",hfWishGroupSeq.Value.Trim()}
                        ,{ "nume_P_UNUM_WISHLIST",hfWishNum.Value.Trim()}
                        ,{ "nvar_P_SVID_USER",Svid_User}
                        ,{ "nvar_P_GOODSFINALCATEGORYCODE",hfCategoryCode.Value.Trim()}

                        };

                WishService.SaveWishListInfo(paramList);
            }
        }
        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('등록되었습니다.');</script>");
        GetWishInfoList();
        GetWishList();
        GetWishGroupList();
    }

    protected void btnOrder_Click(object sender, EventArgs e)
    {
        string cartCode = StringValue.NextCartCode();
        string categoryCodes = string.Empty;
        string groupCodes = string.Empty;
        string goodsCodes = string.Empty;
        string qtys = string.Empty;
        foreach (ListViewItem item in lvWishList.Items)
        {
            CheckBox chSelect = (CheckBox)item.FindControl("chSelect");
            HiddenField hfCategoryCode = (HiddenField)item.FindControl("hfCategoryCode");
            HiddenField hfGoodsGroupCode = (HiddenField)item.FindControl("hfGoodsGroupCode");
            HiddenField hfGoodsCode = (HiddenField)item.FindControl("hfGoodsCode");
            TextBox txtQty = (TextBox)item.FindControl("txtQty");

            if (chSelect.Checked)
            {
                categoryCodes += hfCategoryCode.Value.Trim() + ",";
                groupCodes += hfGoodsGroupCode.Value.Trim() + ",";
                goodsCodes += hfGoodsCode.Value.Trim() + ",";
                qtys += txtQty.Text.Trim() + ",";
            }
        }

        var siteName = SiteName.AsText("socialwith").ToLower();
        string compCode = string.Empty;
        string saleCompCode = string.Empty;
        string freeCompYN = string.Empty;
        if (UserInfoObject != null && UserInfoObject.UserInfo != null)
        {
            compCode = UserInfoObject.UserInfo.PriceCompCode;
            freeCompYN = UserInfoObject.UserInfo.FreeCompanyYN.AsText("N");
            if (siteName != "socialwith")
            {
                saleCompCode = UserInfoObject.UserInfo.SaleCompCode;
            }
        }
        var paramList = new Dictionary<string, object>() {
                     {"nvar_P_SVID_USER", Svid_User}
                    ,{"nvar_P_CARTCODE", cartCode}
                    ,{"nvar_P_GOODSFINALCATEGORYCODES", categoryCodes.TrimEnd(',')}
                    ,{"nvar_P_GOODSGROUPCODES", groupCodes.TrimEnd(',')}
                    ,{"nvar_P_GOODSCODES", goodsCodes.TrimEnd(',')}
                    ,{"nvar_P_QTYS", qtys.TrimEnd(',')}
                    ,{"nvar_P_COMPCODE", compCode}
                    ,{"nvar_P_SALECOMPCODE", saleCompCode}
                    ,{"nvar_P_BDONGSHINCHECK", UserInfoObject.UserInfo.BmroCheck.AsText("N")}
                    ,{"nvar_P_FREECOMPANYYN", freeCompYN}

                 };

        orderService.OrderTryInsertByWish(paramList);

        Response.Redirect("~/Order/OrderList.aspx");
    }
}