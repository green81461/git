using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.ComponentModel.DataAnnotations;
using System.Drawing;
using System.Reflection;
using SocialWith.Biz.Brand;
using SocialWith.Biz.Category;
using SocialWith.Data.Category;

public partial class Admin_Goods_BrandMain : AdminPageBase
{
    BrandService brandService = new BrandService();
     CategoryService categoryService = new CategoryService();
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();

        if (IsPostBack == false)
        {
            DefaultDataBind();
        }
    }

    #region <<파라미터 Get>>
    protected void ParseRequestParameters()
    {
    }

    #endregion

    #region <<데이터바인드>>
    protected void DefaultDataBind()
    {
    }
    
    #endregion

    #region <<이벤트>>

    protected void ucListPager_PageIndexChange(object sender)
    {
    //    BrandDataBind(ucListPager.CurrentPageIndex);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        //BrandDataBind();
        //ucListPager.CurrentPageIndex = 1;
    }

    //엑셀 저장 이벤트
    protected void btnExcelExport_Click(object sender, EventArgs e)
    {
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHKEYWORD", txtSearch.Text.Trim() },
            {"nvar_P_SERACHTARGET",ddlSearchTarget.SelectedValue },
            {"char_P_DELFLAG",ddlSearchDelFlag.SelectedValue }
        };

        var list = brandService.GetExcelBrandList_Admin(paramList);

        var fileName = Server.UrlEncode(AdminId + "_브랜드내역");
        ExportExcel(fileName, list);
    }

    //수정저장 이벤트
    protected void btnSave_Click(object sender, EventArgs e)
    {
        
        //var paramList = new Dictionary<string, object>
        //{
        //    { "char_P_TYPE", "B" },
        //    { "nvar_P_SVID_USER", Svid_User },
        //    { "nvar_P_BRANDCODES",  hfPopupCode.Value.Trim() },
        //    { "nvar_P_DELFLAG", "" },
        //    { "nvar_P_BRANDNAME", txtPopupName.Text.Trim() },
        //    { "nvar_P_REMARK", txtPopupRemark.Text.Trim() },
        //};

        //brandService.DeleteBrand(paramList);
    }

    #endregion

    //엑셀저장 기능
    public void ExportExcel<T>(string fileName, List<T> list)
    {
        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("브랜드내역");
            
            var properties = from property in typeof(T).GetProperties()
                             where Attribute.IsDefined(property, typeof(DisplayAttribute), true)
                             select property;
            
            int headerIndex = 0;
            foreach (PropertyInfo info in properties)
            {
                var displayAttribute = info.GetCustomAttributes(typeof(DisplayAttribute), false).Cast<DisplayAttribute>().Single();

                ws.Cells[1, headerIndex + 1].Value = displayAttribute.Name.ToString();
                headerIndex++;

            }

            if (list != null)
            {
                //populate our Data
                if (list.Count() > 0)
                {
                    ws.Cells["A2"].LoadFromCollection(list);
                    
                    ws.Cells[2, 6, list.Count() + 1, 6].Style.Numberformat.Format = "yyyy-MM-dd";
                    ws.Cells[2, 8, list.Count() + 1, 8].Style.Numberformat.Format = "yyyy-MM-dd";
                    //ws.Cells[2, 11, list.Count() + 1, 13].Style.Numberformat.Format = "#,###원";
                    
                    //Format the header
                    using (ExcelRange rng = ws.Cells[1, 1, 1, 8])
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
                    using (ExcelRange rng = ws.Cells[1, 1, list.Count + 1, 8])
                    {
                        rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                        rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                        rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

                    }
                    //셀 사이즈 오토 세팅
                    using (ExcelRange rng = ws.Cells[1, 1, list.Count + 1, 8])
                    {
                        rng.AutoFitColumns();
                    }

                    for (int i = 1; i <= list.Count(); i++)
                    {
                        ws.Row(i + 1).Height = 36;
                    }
                }
            }
            
            //Write it back to the client
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;  filename=" + fileName + ".xlsx");
            Response.BinaryWrite(pck.GetAsByteArray());
            Response.End();
        }
    }
    
}