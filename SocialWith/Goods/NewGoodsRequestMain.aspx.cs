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
using System.IO;
using SocialWith.Biz.Goods;

public partial class Goods_NewGoodsRequestMain : PageBase
{
    protected CategoryService categoryService = new CategoryService();
    protected GoodsService GoodsService = new GoodsService();

    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack == false)
        {
           // GetCategoryLevelList("1", ""); // 레벨별 카테고리 목록 조회

        }
    }
    
    protected void btnExcelUpload_Click(object sender, EventArgs e)
    {
        if (fuExcel.HasFile)
        {

            try
            {
                string virtualPath = ConfigurationManager.AppSettings["UpLoadFolder"] + "/Temp/";
                string realPath = Server.MapPath(virtualPath + fuExcel.FileName);
                fuExcel.SaveAs(realPath);
                var table = CommonHelper.ExcelToDataTable(realPath, "Sheet1");


                foreach (DataRow dr in table.Rows)
                {
                    if (!string.IsNullOrWhiteSpace(dr["카테고리"].AsText().Trim()))
                    {
                        var paramList = new Dictionary<string, object> {
                            {"nvar_P_NEWGOODSREQNO", StringValue.NextNewGoodCode()},
                            {"nvar_P_SVID_USER", Svid_User},
                            {"nvar_P_GOODSCATEGORYFINALCODE", dr["카테고리"].AsText()},
                            {"nvar_P_GOODSFINALNAME", dr["상품명"].AsText()},
                            {"nvar_P_OPTIONVALUES", dr["규격"].AsText()},
                            {"nvar_P_BRANDNAME", dr["제조사 "].AsText()},
                            {"nvar_P_GOODSMODEL", dr["모델명"].AsText()},
                            {"nvar_P_GOODSORIGINNAME", dr["원산지"].AsText()},
                            {"nvar_P_GOODSUNITNAME", dr["단위"].AsText()},
                            {"nume_P_PROSPECTGOODSQTY", dr["구매예상수량"].AsText()},
                            {"nume_P_NEWGOODSPRICEVAT", dr["기존구매단가"].AsText()},
                            {"nvar_P_NEWGOODSEXPLANDETAIL", dr["품목상세설명"].AsText()},
                            {"nvar_P_NEWGOODSREQSUBJECT", dr["요청사항"].AsText()},
                            {"nvar_P_SVID_ATTACH", ""},

                        };


                        GoodsService.InsertNewGoodReq(paramList);
                    }
                }
            }
            catch (Exception ex)
            {

                logger.Error(ex, "NewGood WriteToServer Error Msg");
                throw;
            }
            finally
            {
                string virtualPath = ConfigurationManager.AppSettings["UpLoadFolder"] + "/Temp/";
                string ttt = Server.MapPath(virtualPath + fuExcel.FileName);
                File.Delete(ttt);
            }
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>fnUploadCompleteMsg();</script>");
            // Response.Redirect("NewGoodsRequestList.aspx");
        }
        else
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('파일을 선택해 주세요.');</script>");
        }
    }
    
    protected void btnExcelFormDownload_Click(object sender, EventArgs e)
    {
        string uploadFolderServerPath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
        string fileName = "우리안 신규견적요청 등록 업로드폼.xlsx";
        string fileFullPath = uploadFolderServerPath + "Form\\" + fileName;

        FileHelper.FileDownload(this.Page, fileFullPath, fileName);
    }
}