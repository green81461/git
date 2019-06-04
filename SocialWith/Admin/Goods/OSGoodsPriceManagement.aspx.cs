using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Goods;
public partial class Admin_Goods_OSGoodsPriceManagement : AdminPageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {

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

                string sheetName = "단가관리";
                bool hasHeaders = false;
                string HDR = hasHeaders ? "Yes" : "No";
                string strConn;

                if (realPath.Substring(realPath.LastIndexOf('.')).ToLower() == ".xlsx")
                    strConn = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + realPath + ";Extended Properties=\"Excel 8.0;HDR=YES;IMEX=1\";";
                else
                    strConn = @"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + realPath + ";Extended Properties=\"Excel 8.0;HDR=YES;IMEX=1\";";

                using (OleDbConnection conn = new OleDbConnection(strConn))
                {
                    conn.Open();
                    var dataCommand = new OleDbCommand("SELECT  * FROM [" + sheetName + "$]", conn);
                    var reader = dataCommand.ExecuteReader();

                    string connectionString = ConfigurationManager.AppSettings["ConnectionString"];

                    using (OracleConnection connection = new OracleConnection(connectionString))
                    {
                        connection.Open();
                        OracleCommand command = new OracleCommand("", connection);
                        InsertGoodsPrice(connection, reader);
                    }
                }

            }
            catch (Exception ex)
            {
                logger.Error(ex, "상품단가업로드에러");
                throw;
            }
            finally
            {
                fuExcel.PostedFile.InputStream.Dispose();
                string virtualPath = ConfigurationManager.AppSettings["UpLoadFolder"] + "/Temp/";
                string ttt = Server.MapPath(virtualPath + fuExcel.FileName);
                File.Delete(ttt);
            }
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('업로드가 완료되었습니다.');</script>");
        }
        else
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('파일을 선택해 주세요.');</script>");
        }
    }

    protected void btnExcelFormDownload_Click(object sender, EventArgs e)
    {
        string uploadFolderServerPath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
        string fileName = "단가관리.xlsx";
        string fileFullPath = uploadFolderServerPath + "Form\\" + fileName;

        FileHelper.FileDownload(this.Page, fileFullPath, fileName);
    }

    protected void InsertGoodsPrice(OracleConnection connection, OleDbDataReader reader)
    {
        GoodsService GoodsService = new GoodsService();
        using (OracleTransaction trans = connection.BeginTransaction())
        {
            try
            {
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {

                        var paramList = new Dictionary<string, object> {
                        {"nvar_P_COMPANY_CODE", reader.GetValue(reader.GetOrdinal("회사코드"))},
                        { "nvar_P_GUBUN", reader.GetValue(reader.GetOrdinal("구분"))},
                        { "nvar_P_COMPANYPRICEID", UserInfoObject.Id},
                        //{"nvar_P_GOODSFINALCATEGORYCODES", ctgrCodes},
                        //{"nvar_P_GOODSGROUPCODES", groupCodes},
                        { "nvar_P_GOODSCODES", reader.GetValue(reader.GetOrdinal("상품코드"))},
                        { "nvar_P_COMPANYPRICES", reader.GetValue(reader.GetOrdinal("단가(VAT미포함)"))},
                    };

                        GoodsService.SaveCompPriceExcel(connection, paramList);
                    }
                }
                trans.Commit();   //커밋
            }
            catch (Exception)
            {
                trans.Rollback();
                throw;
            }

        }
    }
}