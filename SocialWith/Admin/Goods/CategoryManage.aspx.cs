using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Category;
using Urian.Core;
using SocialWith.Data.Category;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.ComponentModel.DataAnnotations;
using System.Drawing;
using System.Reflection;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Globalization;
//using Oracle.DataAccess.Client;
using System.IO;
using System.Text.RegularExpressions;

public partial class Admin_Goods_CategoryManage : AdminPageBase
{
    protected CategoryService categoryService = new CategoryService();
    protected string Ucode;
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        if (IsPostBack == false)
        {
            GetCategoryLevelList("1", ""); // 레벨별 카테고리 목록 조회
            CategoryListBind();
        }
    }

    protected void ParseRequestParameters()
    {
        Ucode = Request.QueryString["ucode"].ToString();
    }

    // 레벨별 카테고리 목록 조회
    protected void GetCategoryLevelList(string level, string upCode)
    {
        // 카테고리 셀렉트박스 초기화
        ClearDdlCtgr(ddlCtgrLevel_2);
        ClearDdlCtgr(ddlCtgrLevel_3);
        ClearDdlCtgr(ddlCtgrLevel_4);
        ClearDdlCtgr(ddlCtgrLevel_5);

        var paramList = new Dictionary<string, object>() {
              {"nvar_P_CATEGORYLEVELCODE", level }
            , {"nvar_P_CATEGORYUPCODE", upCode }
        };

        var categoryList = categoryService.GetCategoryLevelList_Admin(paramList);

        if ((categoryList != null) && (categoryList.Count > 0))
        {

            switch (level)
            {
                case "1":
                    CategoryListSet(ddlCtgrLevel_1, categoryList);
                    break;
                case "2":
                    CategoryListSet(ddlCtgrLevel_2, categoryList);
                    break;
                case "3":
                    CategoryListSet(ddlCtgrLevel_3, categoryList);
                    break;
                case "4":
                    CategoryListSet(ddlCtgrLevel_4, categoryList);
                    break;
                case "5":
                    CategoryListSet(ddlCtgrLevel_5, categoryList);
                    break;
                default:
                    CategoryListSet(ddlCtgrLevel_1, categoryList);
                    break;
            }

        }
    }

    protected void CategoryListSet(DropDownList ddlCtgrLevelTag, List<CategoryDTO> list)
    {
        ddlCtgrLevelTag.DataSource = list;
        ddlCtgrLevelTag.DataTextField = "CategoryFinalName";
        ddlCtgrLevelTag.DataValueField = "CategoryFinalCode";
        ddlCtgrLevelTag.DataBind();
        ddlCtgrLevelTag.Items.Insert(0, new ListItem("전체", ""));
    }

    protected void CategoryListBind(int page = 1)
    {

        int ctgrIndex_1 = ddlCtgrLevel_1.SelectedIndex;
        int ctgrIndex_2 = ddlCtgrLevel_2.SelectedIndex;
        int ctgrIndex_3 = ddlCtgrLevel_3.SelectedIndex;
        int ctgrIndex_4 = ddlCtgrLevel_4.SelectedIndex;
        int ctgrIndex_5 = ddlCtgrLevel_5.SelectedIndex;

        string categoryCode = string.Empty;
        int categoryLevel = 0;
        if (ctgrIndex_5 > 0)
        {
            categoryCode = ddlCtgrLevel_5.SelectedValue;
            categoryLevel = 5;

        }
        else if (ctgrIndex_4 > 0)
        {
            categoryCode = ddlCtgrLevel_4.SelectedValue;
            categoryLevel = 4;
        }
        else if (ctgrIndex_3 > 0)
        {
            categoryCode = ddlCtgrLevel_3.SelectedValue;
            categoryLevel = 3;
        }
        else if (ctgrIndex_2 > 0)
        {
            categoryCode = ddlCtgrLevel_2.SelectedValue;
            categoryLevel = 2;
        }
        else if (ctgrIndex_1 > 0)
        {
            categoryCode = ddlCtgrLevel_1.SelectedValue;
            categoryLevel = 1;
        }

        var paramList = new Dictionary<string, object>{
           {"nume_P_PAGENO", page}
         , {"nume_P_PAGESIZE", 20}
         , {"nvar_P_CATEGORYFINALCODE", categoryCode}
         , {"nume_P_CATEGORYLEVEL", categoryLevel}
         , {"nvar_P_CATEGORYNAME", txtCategoryName.Text.Trim()}
        };
        var list = categoryService.GetCaterotyEdit(paramList);
        int listCount = 0;


        if ((list != null) && (list.Count > 0))
        {
            listCount = list.FirstOrDefault().TotalCount;

        }


        ucListPager.TotalRecordCount = listCount;
        lvMemberListB.DataSource = list;
        lvMemberListB.DataBind();

    }

    protected void saveCaterory(object sender, EventArgs e)
    {
        this.CateGoryFinalCode.Text = Request[this.CateGoryFinalCode.UniqueID];
        this.CategoryLevel.Text = Request[this.CategoryLevel.UniqueID];

        //카테고리 레벨 찾는 부분
        string strText = CategoryLevel.Text;
        string CateGoryLevelCode = "";
        CateGoryLevelCode = Regex.Replace(strText, @"\D", "");



        var paramList = new Dictionary<string, object>
        {
           {"nvar_P_CATEGORYFINALNAME",CateGoryFinalName.Text.Trim() },
           {"nvar_P_CATEGORYFINALCODE",CateGoryFinalCode.Text.Trim() },
           {"nvar_P_CATEGORYLEVELCODE",CateGoryLevelCode},

        };

        categoryService.GetCaterotyUpdate(paramList);
        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('저장되었습니다.');</script>");
        Response.Redirect(string.Format("CategoryManage.aspx?ucode=" + Ucode)); //메인으로 가기.

    }


    protected int Calculate(int a, int b)
    {

        int returnVal = (a * b);
        return returnVal;
    }
    // 카테고리 셀렉트박스 초기화
    protected void ClearDdlCtgr(DropDownList ddl)
    {
        ddl.Items.Clear();
        ddl.Text = string.Empty;
        ddl.Items.Insert(0, new ListItem("전체", ""));
    }


    public void ExportExcel<T>(string fileName, List<T> list)
    {


        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Result");



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

                    //ws.Cells[2, 8, list.Count() + 1, 8].Style.WrapText = true;
                    //ws.Cells[2, 2, list.Count() + 1, 2].Style.Numberformat.Format = "yyyy-MM-dd";
                    //ws.Cells[2, 10, list.Count() + 1, 10].Style.Numberformat.Format = "#,###";
                    //ws.Cells[2, 11, list.Count() + 1, 13].Style.Numberformat.Format = "#,###원";


                    //Format the header
                    using (ExcelRange rng = ws.Cells[1, 1, 1, 7])
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
                    using (ExcelRange rng = ws.Cells[2, 1, list.Count + 1, 7])
                    {
                        rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                        rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                        rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

                    }
                    //셀 사이즈 오토 세팅
                    using (ExcelRange rng = ws.Cells[1, 1, list.Count + 1, 7])
                    {
                        rng.AutoFitColumns();
                    }

                    for (int i = 1; i <= list.Count(); i++)
                    {
                        ws.Row(i + 1).Height = 26;
                    }
                }
            }

            //Write it back to the client
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;  filename=" + Server.UrlEncode(fileName) + ".xlsx");
            Response.BinaryWrite(pck.GetAsByteArray());
            Response.End();
        }
    }

    protected string SetFlagName(string value)
    {

        string returnVal = "사용";
        if (!string.IsNullOrWhiteSpace(value))
        {
            if (value == "N")
            {
                returnVal = "사용";
            }
            else
            {
                returnVal = "사용중지";
            }
        }

        return returnVal;
    }

    protected string SetFlagImg(string value)
    {
        if (value == "N")
        {
            return "btn_use_s.png";
        }
        else
        {
            return "btn_nouse_s.png";
        }
    }

    #region << 이벤트 >>
    //카테고리 1레벨 이벤트
    protected void ddlCtgrLevel_1_Changed(object sender, EventArgs e)
    {
        int selectIdx = ddlCtgrLevel_1.SelectedIndex;

        if (selectIdx > 0)
        {
            string ctgrCode = ddlCtgrLevel_1.SelectedValue;

            var paramList = new Dictionary<string, object>() {
                  {"nvar_P_CATEGORYLEVELCODE", "2" }
                , {"nvar_P_CATEGORYUPCODE", ctgrCode }
            };

            var categoryList = categoryService.GetCategoryLevelList_Admin(paramList);

            if ((categoryList != null) && (categoryList.Count > 0))
            {
                CategoryListSet(ddlCtgrLevel_2, categoryList);

                ClearDdlCtgr(ddlCtgrLevel_3);
                ClearDdlCtgr(ddlCtgrLevel_4);
                ClearDdlCtgr(ddlCtgrLevel_5);
            }
        }
        else
        {
            // 카테고리 셀렉트박스 초기화
            ClearDdlCtgr(ddlCtgrLevel_2);
            ClearDdlCtgr(ddlCtgrLevel_3);
            ClearDdlCtgr(ddlCtgrLevel_4);
            ClearDdlCtgr(ddlCtgrLevel_5);
        }
    }

    //카테고리 2레벨 이벤트
    protected void ddlCtgrLevel_2_Changed(object sender, EventArgs e)
    {
        int selectIdx = ddlCtgrLevel_2.SelectedIndex;

        if (selectIdx > 0)
        {
            string ctgrCode = ddlCtgrLevel_2.SelectedValue;

            var paramList = new Dictionary<string, object>() {
                  {"nvar_P_CATEGORYLEVELCODE", "3" }
                , {"nvar_P_CATEGORYUPCODE", ctgrCode }
            };

            var categoryList = categoryService.GetCategoryLevelList_Admin(paramList);

            if ((categoryList != null) && (categoryList.Count > 0))
            {
                CategoryListSet(ddlCtgrLevel_3, categoryList);

                // 카테고리 셀렉트박스 초기화
                ClearDdlCtgr(ddlCtgrLevel_4);
                ClearDdlCtgr(ddlCtgrLevel_5);
            }
        }
        else
        {
            // 카테고리 셀렉트박스 초기화
            ClearDdlCtgr(ddlCtgrLevel_3);
            ClearDdlCtgr(ddlCtgrLevel_4);
            ClearDdlCtgr(ddlCtgrLevel_5);
        }
    }

    //카테고리 3레벨 이벤트
    protected void ddlCtgrLevel_3_Changed(object sender, EventArgs e)
    {
        int selectIdx = ddlCtgrLevel_3.SelectedIndex;

        if (selectIdx > 0)
        {
            string ctgrCode = ddlCtgrLevel_3.SelectedValue;

            var paramList = new Dictionary<string, object>() {
                  {"nvar_P_CATEGORYLEVELCODE", "4" }
                , {"nvar_P_CATEGORYUPCODE", ctgrCode }
            };

            var categoryList = categoryService.GetCategoryLevelList_Admin(paramList);

            if ((categoryList != null) && (categoryList.Count > 0))
            {
                CategoryListSet(ddlCtgrLevel_4, categoryList);

                // 카테고리 셀렉트박스 초기화
                ClearDdlCtgr(ddlCtgrLevel_5);
            }
        }
        else
        {
            // 카테고리 셀렉트박스 초기화
            ClearDdlCtgr(ddlCtgrLevel_4);
            ClearDdlCtgr(ddlCtgrLevel_5);
        }
    }

    //카테고리 4레벨 이벤트
    protected void ddlCtgrLevel_4_Changed(object sender, EventArgs e)
    {
        int selectIdx = ddlCtgrLevel_4.SelectedIndex;

        if (selectIdx > 0)
        {
            string ctgrCode = ddlCtgrLevel_4.SelectedValue;

            var paramList = new Dictionary<string, object>() {
                  {"nvar_P_CATEGORYLEVELCODE", "5" }
                , {"nvar_P_CATEGORYUPCODE", ctgrCode }
            };

            var categoryList = categoryService.GetCategoryLevelList_Admin(paramList);

            if ((categoryList != null) && (categoryList.Count > 0))
            {
                CategoryListSet(ddlCtgrLevel_5, categoryList);
            }
        }
        else
        {
            // 카테고리 셀렉트박스 초기화
            ClearDdlCtgr(ddlCtgrLevel_5);
        }
    }

    protected void btnExcelExport_Click(object sender, EventArgs e)
    {
        int ctgrIndex_1 = ddlCtgrLevel_1.SelectedIndex;
        int ctgrIndex_2 = ddlCtgrLevel_2.SelectedIndex;
        int ctgrIndex_3 = ddlCtgrLevel_3.SelectedIndex;
        int ctgrIndex_4 = ddlCtgrLevel_4.SelectedIndex;
        int ctgrIndex_5 = ddlCtgrLevel_5.SelectedIndex;

        string categoryCode = string.Empty;
        int categoryLevel = 0;
        if (ctgrIndex_5 > 0)
        {
            categoryCode = ddlCtgrLevel_5.SelectedValue;
            categoryLevel = 5;

        }
        else if (ctgrIndex_4 > 0)
        {
            categoryCode = ddlCtgrLevel_4.SelectedValue;
            categoryLevel = 4;
        }
        else if (ctgrIndex_3 > 0)
        {
            categoryCode = ddlCtgrLevel_3.SelectedValue;
            categoryLevel = 3;
        }
        else if (ctgrIndex_2 > 0)
        {
            categoryCode = ddlCtgrLevel_2.SelectedValue;
            categoryLevel = 2;
        }
        else if (ctgrIndex_1 > 0)
        {
            categoryCode = ddlCtgrLevel_1.SelectedValue;
            categoryLevel = 1;
        }

        var paramList = new Dictionary<string, object>{
          {"nvar_P_CATEGORYFINALCODE", categoryCode}
         , {"nume_P_CATEGORYLEVEL", categoryLevel}
         , {"nvar_P_CATEGORYNAME", txtCategoryName.Text.Trim()}
        };
        var list = categoryService.GetCaterotyEditExcel(paramList);

        list.ForEach(p => p.DelFlag = SetFlagName(p.DelFlag));
        string fileName = AdminId + "_카테고리 내역";
        ExportExcel(fileName, list);
    }

    protected void ucListPager_PageIndexChange(object sender)
    {
        CategoryListBind(ucListPager.CurrentPageIndex);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        CategoryListBind(1);
        ucListPager.CurrentPageIndex = 1;
    }

    protected void lvMemberListB_ItemDataBound(object sender, ListViewItemEventArgs e)
    {
        if (e.Item.ItemType == ListViewItemType.DataItem)         //구분값에 따른 컬럼 헤더 visible처리
        {
            ListViewDataItem dataItem = (ListViewDataItem)e.Item;

            ImageButton ibtnCategoryDelete = (ImageButton)dataItem.FindControl("ibtnCategoryDelete");
            ImageButton ibtnCategoryUse = (ImageButton)dataItem.FindControl("ibtnCategoryUse");
            HiddenField hfDelFlag = (HiddenField)dataItem.FindControl("hfDelFlag");

            if (ibtnCategoryDelete != null && ibtnCategoryUse != null && hfDelFlag != null)
            {
                if (hfDelFlag.Value == "N" || string.IsNullOrWhiteSpace(hfDelFlag.Value))
                {
                    ibtnCategoryDelete.Visible = true;
                    ibtnCategoryUse.Visible = false;
                }
                else
                {
                    ibtnCategoryDelete.Visible = false;
                    ibtnCategoryUse.Visible = true;
                }
            }
        }
    }

    protected void btnExcelFormDownload_Click(object sender, EventArgs e)
    {
        string uploadFolderServerPath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
        string fileName = "우리안 상품 카테고리 업로드폼.xlsx";
        string fileFullPath = uploadFolderServerPath + "Form\\" + fileName;

        FileHelper.FileDownload(this.Page, fileFullPath, fileName);
    }

    protected void btnExcelUpload_Click(object sender, EventArgs e)
    {
        if (fuExcel.HasFile)
        {
            try
            {
                //   string path = Path.GetFullPath(fuExcel.PostedFile.FileName);
                string virtualPath = ConfigurationManager.AppSettings["UpLoadFolder"] + "/Temp/";
                string realPath = Server.MapPath(virtualPath + fuExcel.FileName);
                fuExcel.SaveAs(realPath);
                var table = ExcelToDataTable(realPath);
                //var table = GetDataTableFromCsv(ttt, true);

                table.Columns.Add("ENTRYDATE", typeof(DateTime));

                foreach (DataRow row in table.Rows)
                {
                    row["ENTRYDATE"] = String.Format("{0:yyyy-MM-dd HH:mm:ss}", DateTime.Now);
                }

                try
                {
                    var param = new Dictionary<string, object> { };
                    //categoryService.DeleteAllCategory(param);
                }
                catch (Exception ex)
                {
                    logger.Error(ex, "All CategoryDelete Error Msg={0}");
                    throw;
                }


                var connectionstring = ConfigurationManager.ConnectionStrings["UrianTestDB"].ConnectionString;
                // WriteToServer(connectionstring, "U_CATEGORY", table);
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                string virtualPath = ConfigurationManager.AppSettings["UpLoadFolder"] + "/Temp/";
                string ttt = Server.MapPath(virtualPath + fuExcel.FileName);
                File.Delete(ttt);
            }
        }
        else
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('파일을 선택해 주세요.');</script>");
        }
    }
    #endregion

    public static DataTable ExcelToDataTable(string filePath)
    {
        DataTable dtexcel = new DataTable();
        bool hasHeaders = false;
        string HDR = hasHeaders ? "Yes" : "No";
        string strConn;

        if (filePath.Substring(filePath.LastIndexOf('.')).ToLower() == ".xlsx")
            strConn = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filePath + ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=1\";";
        else
            strConn = @"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filePath + ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=1\";";
        OleDbConnection conn = new OleDbConnection(strConn);
        conn.Open();
        DataTable schemaTable = conn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, new object[] { null, null, null, "TABLE" });


        string query = "SELECT  * FROM [합본$]";
        OleDbDataAdapter daexcel = new OleDbDataAdapter(query, conn);
        dtexcel.Locale = CultureInfo.CurrentCulture;
        daexcel.Fill(dtexcel);
        conn.Close();
        return dtexcel;

    }

}