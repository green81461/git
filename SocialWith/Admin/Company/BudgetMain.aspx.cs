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

public partial class Admin_Company_BudgetMain : AdminPageBase
{
    protected string Ucode;
    protected CompanyService companyService = new CompanyService();
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
    }
    protected void ParseRequestParameters()
    {

        Ucode = Request.QueryString["ucode"].ToString();
    }




    //public void WriteToServer(string connectionString, string qualifiedDBName, DataTable dataTable)
    //{
    //    using (var connection = new OracleConnection(connectionString))
    //    {
    //        connection.Open();
    //        using (var bulkCopy = new OracleBulkCopy(connection, OracleBulkCopyOptions.UseInternalTransaction))
    //        {
    //            bulkCopy.DestinationTableName = qualifiedDBName;
    //            bulkCopy.ColumnMappings.Add("년도", "YYYY");
    //            bulkCopy.ColumnMappings.Add("월", "MM");
    //            bulkCopy.ColumnMappings.Add("사업자번호", "COMPANY_NO");
    //            bulkCopy.ColumnMappings.Add("고유번호", "UNIQUE_NO");
    //            bulkCopy.ColumnMappings.Add("회사명", "COMPANY_CODE");
    //            bulkCopy.ColumnMappings.Add("사업장명", "COMPANYAREA_CODE");
    //            bulkCopy.ColumnMappings.Add("사업부명", "COMPBUSINESSDEPT_CODE");
    //            bulkCopy.ColumnMappings.Add("부서명", "COMPANYDEPT_CODE");
    //            bulkCopy.ColumnMappings.Add("특수필드", "SVID_USER");
    //            bulkCopy.ColumnMappings.Add("예산금액", "BUDGETCOST");
    //            bulkCopy.ColumnMappings.Add("예산금액", "BUDGETTOTALCOST");
    //            bulkCopy.ColumnMappings.Add("예산금액", "BUDGETREMAINCOST");
    //            bulkCopy.ColumnMappings.Add("등록날짜", "ENTRYDATE");

    //            try
    //            {
    //                bulkCopy.WriteToServer(dataTable.AsEnumerable().Distinct(new BoxEqualityComparer()).CopyToDataTable());
    //                //bulkCopy.WriteToServer(dataTable);
    //            }
    //            catch (Exception ex)
    //            {
    //                logger.ErrorFormat("Budget WriteToServer Error Msg={0}", ex);
    //                throw;
    //            }
    //            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('업로드 완료 되었습니다.');</script>");
    //        }
    //    }
    //}

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

                        {"nvar_P_YYYY", dr["년도"].AsText() },
                        {"nvar_P_MM", dr["월"].AsText() },
                        {"nvar_P_COMPANY_NO", dr["사업자번호"].AsText() },
                        {"nvar_P_UNIQUE_NO", dr["고유번호"].AsText() },
                        {"nvar_P_COMPANY_CODE", dr["회사명"].AsText() },
                        {"nvar_P_COMPANYAREA_CODE", dr["사업장명"].AsText() },
                        {"nvar_P_COMPBUSINESSDEPT_CODE", dr["사업부명"].AsText() },
                        {"nvar_P_COMPANYDEPT_CODE", dr["부서명"].AsText() },
                        {"nvar_P_SVID_USER", Svid_User},
                        {"nume_P_BUDGETCOST", dr["예산금액"].AsDecimal() },

                    };
                    companyService.SaveBudgetExcel(param);
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
        string fileName = "우리안 예산관리 업로드폼.xlsx";
        string fileFullPath = uploadFolderServerPath + "Form\\" + fileName;

        FileHelper.FileDownload(this.Page, fileFullPath, fileName);
    }
}
