using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Comapny;
using Urian.Core;

public partial class Admin_Company_BudgetAccountMain : AdminPageBase
{
    protected string Ucode;
    protected CompanyService companyService = new CompanyService();
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();

    }
    protected void ParseRequestParameters()
    {

        //  Svid = Request.QueryString["Svid"].ToString();
        Ucode = Request.QueryString["ucode"].ToString();
    }
    protected void ibtnExcelUpload_Click(object sender, EventArgs e)
    {
        if (fuExcel.HasFile)
        {
            try
            {
                //   string path = Path.GetFullPath(fuExcel.PostedFile.FileName);
                string virtualPath = ConfigurationManager.AppSettings["UpLoadFolder"] + "/Temp/";
                string realPath = Server.MapPath(virtualPath + fuExcel.FileName);
                fuExcel.SaveAs(realPath);
                var table = CommonHelper.ExcelToDataTable(realPath, "합본");
                //var table = GetDataTableFromCsv(ttt, true);


                foreach (DataRow dr in table.Rows)
                {
                    var param = new Dictionary<string, object> {

                        {"nvar_P_COMPANY_NO", dr["사업자코드"].AsText() },
                        {"nvar_P_COMPANY_CODE", dr["회사명"].AsText() },
                        {"nvar_P_UNIQUE_NO", dr["고유번호"].AsText() },
                        {"nvar_P_BUDGETACCOUNTCODE", dr["순번"].AsText() },
                        {"nvar_P_SVID_USER", Svid_User },
                        {"nvar_P_BUDGETACCOUNTNAME", dr["계정명"].AsText() },
                        {"nvar_P_REMARK", dr["비고"].AsText() },

                    };
                    companyService.SaveBudgetAccountExcel(param);
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Budget WriteToServer Error Msg");
                throw;
            }
            finally
            {
                string virtualPath = ConfigurationManager.AppSettings["UpLoadFolder"] + "/Temp/";
                string ttt = Server.MapPath(virtualPath + fuExcel.FileName);
                File.Delete(ttt);
            }

            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('업로드 완료 되었습니다.');</script>");
        }
        else
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('파일을 선택해 주세요.');</script>");
        }
    }

    protected void ibtnExcelFormDownload_Click(object sender, EventArgs e)
    {
        string uploadFolderServerPath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
        string fileName = "우리안 예산계정 업로드폼.xlsx";
        string fileFullPath = uploadFolderServerPath + "Form\\" + fileName;

        FileHelper.FileDownload(this.Page, fileFullPath, fileName);
    }
}