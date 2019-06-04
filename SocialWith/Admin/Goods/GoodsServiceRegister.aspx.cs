using OfficeOpenXml;
using OfficeOpenXml.Style;
using Oracle.ManagedDataAccess.Client;
//using Oracle.DataAccess.Client;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Excel;
using SocialWith.Biz.Goods;
using Urian.Core;

public partial class Admin_Goods_GoodsRegister : AdminPageBase
{
    protected string GoodsCode;
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();

    }

    protected void ParseRequestParameters()
    {
        GoodsCode = Request.QueryString["GoodsCode"].AsText();
    }


    protected void ibtnImgSave_Click(object sender, ImageClickEventArgs e)
    {

    }

    protected void btnExcelFormDownload_Click(object sender, EventArgs e)
    {
        string uploadFolderServerPath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
        string fileName = "우리안 신규상품 업로드폼.xlsx";
        string fileFullPath = uploadFolderServerPath + "Form\\" + fileName;

        FileHelper.FileDownload(this.Page, fileFullPath, fileName);
    }

    
    //protected void btnExcelUpload_Click(object sender, EventArgs e)
    //{
    //    if (fuExcel.HasFile)
    //    {
    //        try
    //        {
    //            //   string path = Path.GetFullPath(fuExcel.PostedFile.FileName);
    //            string virtualPath = ConfigurationManager.AppSettings["UpLoadFolder"] + "/Temp/";
    //            string realPath = Server.MapPath(virtualPath + fuExcel.FileName);
    //            fuExcel.SaveAs(realPath);

    //            string sheetName = "합본";
    //            bool hasHeaders = false;
    //            string HDR = hasHeaders ? "Yes" : "No";
    //            string strConn;

    //            if (realPath.Substring(realPath.LastIndexOf('.')).ToLower() == ".xlsx")
    //                strConn = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + realPath + ";Extended Properties=\"Excel 8.0;HDR=YES;IMEX=1\";";
    //            else
    //                strConn = @"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + realPath + ";Extended Properties=\"Excel 8.0;HDR=YES;IMEX=1\";";

    //            using (OleDbConnection conn = new OleDbConnection(strConn))
    //            {
    //                conn.Open();
    //                var dataCommand = new OleDbCommand("SELECT  * FROM [" + sheetName + "$]", conn);
    //                var reader = dataCommand.ExecuteReader();

    //                string connectionString = ConfigurationManager.AppSettings["ConnectionString"];

    //                using (OracleConnection connection = new OracleConnection(connectionString))
    //                {
    //                    connection.Open();
    //                    OracleCommand command = new OracleCommand("", connection);
    //                    InsertGoodsImsi(connection, reader);
    //                }
    //            }

    //        }
    //        catch (Exception ex)
    //        {
    //            logger.Error(ex, "신규상품업로드에러");
    //            throw;
    //        }
    //        finally
    //        {
    //            fuExcel.PostedFile.InputStream.Dispose();
    //            string virtualPath = ConfigurationManager.AppSettings["UpLoadFolder"] + "/Temp/";
    //            string ttt = Server.MapPath(virtualPath + fuExcel.FileName);
    //            File.Delete(ttt);
    //        }
    //        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('상품임시 테이블에 업로드가 완료되었습니다.');</script>");
    //    }
    //    else
    //    {
    //        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('파일을 선택해 주세요.');</script>");
    //    }
    //}

    protected void InsertGoodsImsi(OracleConnection connection, OleDbDataReader reader)
    {

        using (OracleTransaction trans = connection.BeginTransaction())
        {
            string insertQuery = @"INSERT INTO U_GOODSIMSI
                   (
                          GOODSCATEGORYFINALCODE,
                          GOODSCATEGORYUPCODE,
                          GOODSCATEGORYFINALNAME,
                          GOODSCATEGORY1LEVELCODE,
                          GOODSCATEGORY1LEVELNAME,
                          GOODSCATEGORY2LEVELCODE,
                          GOODSCATEGORY2LEVELNAME,
                          GOODSCATEGORY3LEVELCODE,
                          GOODSCATEGORY3LEVELNAME,
                          GOODSCATEGORY4LEVELCODE,
                          GOODSCATEGORY4LEVELNAME,
                          GOODSCATEGORY5LEVELCODE,
                          GOODSCATEGORY5LEVELNAME,
                          GOODSCATEGORY6LEVELCODE,
                          GOODSCATEGORY6LEVELNAME,
                          GOODSCATEGORY7LEVELCODE,
                          GOODSCATEGORY7LEVELNAME,
                          GOODSCATEGORY8LEVELCODE,
                          GOODSCATEGORY8LEVELNAME,
                          GOODSCATEGORY9LEVELCODE,
                          GOODSCATEGORY9LEVELNAME,
                          GOODSCATEGORY10LEVELCODE,
                          GOODSCATEGORY10LEVELNAME,
                          MDTOID,
                          MDMEMO,
                          BRANDCODE,
                          GOODSGROUPCODE,
                          GOODSCODE,
                          GOODSFINALNAME,
                          GOODSMODEL,
                          GOODSUNITMOQ,
                          GOODSDELIVERYORDERDUE,
                          GOODSUNITQTY,
                          GOODSUNIT,
                          GOODSUNITSUBQTY,
                          GOODSSUBUNIT,
                          GOODSSPECIAL,
                          GOODSFORMAT,
                          GOODSCAUSE,
                          GOODSSUPPLIES,
                          GOODSOPTIONSUMMARYCODE,
                          GOODSOPTIONCATION1,
                          GOODSOPTIONVALUES1,
                          GOODSOPTIONCATION2,
                          GOODSOPTIONVALUES2,
                          GOODSOPTIONCATION3,
                          GOODSOPTIONVALUES3,
                          GOODSOPTIONCATION4,
                          GOODSOPTIONVALUES4,
                          GOODSOPTIONCATION5,
                          GOODSOPTIONVALUES5,
                          GOODSOPTIONCATION6,
                          GOODSOPTIONVALUES6,
                          GOODSOPTIONCATION7,
                          GOODSOPTIONVALUES7,
                          GOODSOPTIONCATION8,
                          GOODSOPTIONVALUES8,
                          GOODSOPTIONCATION9,
                          GOODSOPTIONVALUES9,
                          GOODSOPTIONCATION10,
                          GOODSOPTIONVALUES10,
                          GOODSOPTIONCATION11,
                          GOODSOPTIONVALUES11,
                          GOODSOPTIONCATION12,
                          GOODSOPTIONVALUES12,
                          GOODSOPTIONCATION13,
                          GOODSOPTIONVALUES13,
                          GOODSOPTIONCATION14,
                          GOODSOPTIONVALUES14,
                          GOODSOPTIONCATION15,
                          GOODSOPTIONVALUES15,
                          GOODSOPTIONCATION16,
                          GOODSOPTIONVALUES16,
                          GOODSOPTIONCATION17,
                          GOODSOPTIONVALUES17,
                          GOODSOPTIONCATION18,
                          GOODSOPTIONVALUES18,
                          GOODSOPTIONCATION19,
                          GOODSOPTIONVALUES19,
                          GOODSOPTIONCATION20,
                          GOODSOPTIONVALUES20,
                          GOODSREMINDSEARCH,
                          GOODSALIKESEARCH,
                          GOODSMDSEQ,
                          GOODSDISPLAYFLAG,
                          GOODSNODISPLYREASON,
                          GOODSNOSALEREASON,
                          GOODSNOSALEENTERTARGETDUE,
                          GOODSRETURNCHANGEFLAG,
                          GOODSKEEPYN,
                          GOODSSALETAXYN,
                          GOODSDCYN,
                          GOODSCUSTGUBUN,
                          GOODSSALECUSTGUBUNCODE,
                          GOODSBUYPRICE,
                          GOODSBUYPRICEVAT,
                          GOODSCUSTPRICE,
                          GOODSCUSTPRICEVAT,
                          GOODSSALEPRICE,
                          GOODSSALEPRICEVAT,
                          GOODSMSALEPRICE,
                          GOODSMSALEPRICEVAT,
                          SUPPLYBUYGOODSTYPE,
                          SUPPLYGOODSUNIT,
                          SUPPLYGOODSDISTRADMIN,
                          GOODSORIGINCODE,
                          GOODSSUPPLYCBARCODE1,
                          GOODSSUPPLYCBARCODE2,
                          GOODSSUPPLYCBARCODE3,
                          GOODSCONFIRMMARK,
                          SUPPLYCOMPANYCODE1,
                          SUPPLYGOODSCODE1,
                          GOODSSUPPLYBARCODE,
                          SUPPLYGOODSUNITMOQ,
                          SUPPLYGOODSENTERDUE,
                          SUPPLYBUYCALC,
                          SUPPLYORDERFORM,
                          SUPPLYTRANSCOSTYN,
                          SUPPLYTRANSCOSTVAT,
                          SUPPLYGOODSDISTRDUE,
                          SUPPLYCOMPANYCODE2,
                          SUPPLYGOODSCODE2,
                          GOODSSUPPLYBARCODE2,
                          SUPPLYGOODSUNITMOQ2,
                          SUPPLYGOODSENTERDUE2,
                          SUPPLYBUYCALC2,
                          SUPPLYORDERFORM2,
                          SUPPLYTRANSCOSTYN2,
                          SUPPLYTRANSCOSTVAT2,
                          SUPPLYGOODSDISTRDUE2,
                          SUPPLYCOMPANYCODE3,
                          SUPPLYGOODSCODE3,
                          GOODSSUPPLYBARCODE3,
                          SUPPLYGOODSUNITMOQ3,
                          SUPPLYGOODSENTERDUE3,
                          SUPPLYBUYCALC3,
                          SUPPLYORDERFORM3,
                          SUPPLYTRANSCOSTYN3,
                          SUPPLYTRANSCOSTVAT3,
                          SUPPLYGOODSDISTRDUE3,
                          DELIVERYGUBUN,
                          DELIVERYCOSTGUBUN,
                          DELIVERYCOST_CODE,
                          ENTRYDATE
                   )
                   VALUES
                   (
                          :GOODSCATEGORYFINALCODE,
                          :GOODSCATEGORYUPCODE,
                          :GOODSCATEGORYFINALNAME,
                          :GOODSCATEGORY1LEVELCODE,
                          :GOODSCATEGORY1LEVELNAME,
                          :GOODSCATEGORY2LEVELCODE,
                          :GOODSCATEGORY2LEVELNAME,
                          :GOODSCATEGORY3LEVELCODE,
                          :GOODSCATEGORY3LEVELNAME,
                          :GOODSCATEGORY4LEVELCODE,
                          :GOODSCATEGORY4LEVELNAME,
                          :GOODSCATEGORY5LEVELCODE,
                          :GOODSCATEGORY5LEVELNAME,
                          :GOODSCATEGORY6LEVELCODE,
                          :GOODSCATEGORY6LEVELNAME,
                          :GOODSCATEGORY7LEVELCODE,
                          :GOODSCATEGORY7LEVELNAME,
                          :GOODSCATEGORY8LEVELCODE,
                          :GOODSCATEGORY8LEVELNAME,
                          :GOODSCATEGORY9LEVELCODE,
                          :GOODSCATEGORY9LEVELNAME,
                          :GOODSCATEGORY10LEVELCODE,
                          :GOODSCATEGORY10LEVELNAME,
                          :MDTOID,
                          :MDMEMO,
                          :BRANDCODE,
                          :GOODSGROUPCODE,
                          :GOODSCODE,
                          :GOODSFINALNAME,
                          :GOODSMODEL,
                          :GOODSUNITMOQ,
                          :GOODSDELIVERYORDERDUE,
                          :GOODSUNITQTY,
                          :GOODSUNIT,
                          :GOODSUNITSUBQTY,
                          :GOODSSUBUNIT,
                          :GOODSSPECIAL,
                          :GOODSFORMAT,
                          :GOODSCAUSE,
                          :GOODSSUPPLIES,
                          :GOODSOPTIONSUMMARYCODE,
                          :GOODSOPTIONCATION1,
                          :GOODSOPTIONVALUES1,
                          :GOODSOPTIONCATION2,
                          :GOODSOPTIONVALUES2,
                          :GOODSOPTIONCATION3,
                          :GOODSOPTIONVALUES3,
                          :GOODSOPTIONCATION4,
                          :GOODSOPTIONVALUES4,
                          :GOODSOPTIONCATION5,
                          :GOODSOPTIONVALUES5,
                          :GOODSOPTIONCATION6,
                          :GOODSOPTIONVALUES6,
                          :GOODSOPTIONCATION7,
                          :GOODSOPTIONVALUES7,
                          :GOODSOPTIONCATION8,
                          :GOODSOPTIONVALUES8,
                          :GOODSOPTIONCATION9,
                          :GOODSOPTIONVALUES9,
                          :GOODSOPTIONCATION10,
                          :GOODSOPTIONVALUES10,
                          :GOODSOPTIONCATION11,
                          :GOODSOPTIONVALUES11,
                          :GOODSOPTIONCATION12,
                          :GOODSOPTIONVALUES12,
                          :GOODSOPTIONCATION13,
                          :GOODSOPTIONVALUES13,
                          :GOODSOPTIONCATION14,
                          :GOODSOPTIONVALUES14,
                          :GOODSOPTIONCATION15,
                          :GOODSOPTIONVALUES15,
                          :GOODSOPTIONCATION16,
                          :GOODSOPTIONVALUES16,
                          :GOODSOPTIONCATION17,
                          :GOODSOPTIONVALUES17,
                          :GOODSOPTIONCATION18,
                          :GOODSOPTIONVALUES18,
                          :GOODSOPTIONCATION19,
                          :GOODSOPTIONVALUES19,
                          :GOODSOPTIONCATION20,
                          :GOODSOPTIONVALUES20,
                          :GOODSREMINDSEARCH,
                          :GOODSALIKESEARCH,
                          :GOODSMDSEQ,
                          :GOODSDISPLAYFLAG,
                          :GOODSNODISPLYREASON,
                          :GOODSNOSALEREASON,
                          :GOODSNOSALEENTERTARGETDUE,
                          :GOODSRETURNCHANGEFLAG,
                          :GOODSKEEPYN,
                          :GOODSSALETAXYN,
                          :GOODSDCYN,
                          :GOODSCUSTGUBUN,
                          :GOODSSALECUSTGUBUNCODE,
                          :GOODSBUYPRICE,
                          :GOODSBUYPRICEVAT,
                          :GOODSCUSTPRICE,
                          :GOODSCUSTPRICEVAT,
                          :GOODSSALEPRICE,
                          :GOODSSALEPRICEVAT,
                          :GOODSMSALEPRICE,
                          :GOODSMSALEPRICEVAT,
                          :SUPPLYBUYGOODSTYPE,
                          :SUPPLYGOODSUNIT,
                          :SUPPLYGOODSDISTRADMIN,
                          :GOODSORIGINCODE,
                          :GOODSSUPPLYCBARCODE1,
                          :GOODSSUPPLYCBARCODE2,
                          :GOODSSUPPLYCBARCODE3,
                          :GOODSCONFIRMMARK,
                          :SUPPLYCOMPANYCODE1,
                          :SUPPLYGOODSCODE1,
                          :GOODSSUPPLYBARCODE,
                          :SUPPLYGOODSUNITMOQ,
                          :SUPPLYGOODSENTERDUE,
                          :SUPPLYBUYCALC,
                          :SUPPLYORDERFORM,
                          :SUPPLYTRANSCOSTYN,
                          :SUPPLYTRANSCOSTVAT,
                          :SUPPLYGOODSDISTRDUE,
                          :SUPPLYCOMPANYCODE2,
                          :SUPPLYGOODSCODE2,
                          :GOODSSUPPLYBARCODE2,
                          :SUPPLYGOODSUNITMOQ2,
                          :SUPPLYGOODSENTERDUE2,
                          :SUPPLYBUYCALC2,
                          :SUPPLYORDERFORM2,
                          :SUPPLYTRANSCOSTYN2,
                          :SUPPLYTRANSCOSTVAT2,
                          :SUPPLYGOODSDISTRDUE2,
                          :SUPPLYCOMPANYCODE3,
                          :SUPPLYGOODSCODE3,
                          :GOODSSUPPLYBARCODE3,
                          :SUPPLYGOODSUNITMOQ3,
                          :SUPPLYGOODSENTERDUE3,
                          :SUPPLYBUYCALC3,
                          :SUPPLYORDERFORM3,
                          :SUPPLYTRANSCOSTYN3,
                          :SUPPLYTRANSCOSTVAT3,
                          :SUPPLYGOODSDISTRDUE3,
                          :DELIVERYGUBUN,
                          :DELIVERYCOSTGUBUN,
                          :DELIVERYCOST_CODE,
                          SYSDATE
                   )";

            if (reader.HasRows)
            {
                while (reader.Read())
                {


                    OracleCommand insertcommand = new OracleCommand(insertQuery, connection);
                    //insertcommand.Transaction = transaction;
                    insertcommand.CommandType = CommandType.Text;

                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORYFINALCODE", reader.GetValue(reader.GetOrdinal("최종카테고리"))));//최종카테고리
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORYUPCODE", reader.GetValue(reader.GetOrdinal("상위카테고리 코드"))));//상위카테고리 코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORYFINALNAME", reader.GetValue(reader.GetOrdinal("최종카테고리명"))));//최종카테고리명
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY1LEVELCODE", reader.GetValue(reader.GetOrdinal("카테고리1단코드"))));//카테고리1단코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY1LEVELNAME", reader.GetValue(reader.GetOrdinal("카테고리1단명"))));//카테고리1단명
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY2LEVELCODE", reader.GetValue(reader.GetOrdinal("카테고리2단코드"))));//카테고리2단코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY2LEVELNAME", reader.GetValue(reader.GetOrdinal("카테고리2단명"))));//카테고리2단명
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY3LEVELCODE", reader.GetValue(reader.GetOrdinal("카테고리3단코드"))));//카테고리3단코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY3LEVELNAME", reader.GetValue(reader.GetOrdinal("카테고리3단명"))));//카테고리3단명
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY4LEVELCODE", reader.GetValue(reader.GetOrdinal("카테고리4단코드"))));//카테고리4단코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY4LEVELNAME", reader.GetValue(reader.GetOrdinal("카테고리4단명"))));//카테고리4단명
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY5LEVELCODE", reader.GetValue(reader.GetOrdinal("카테고리5단코드"))));//카테고리5단코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY5LEVELNAME", reader.GetValue(reader.GetOrdinal("카테고리5단명"))));//카테고리5단명
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY6LEVELCODE", reader.GetValue(reader.GetOrdinal("6코드"))));//6코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY6LEVELNAME", reader.GetValue(reader.GetOrdinal("6코드명"))));//6코드명
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY7LEVELCODE", reader.GetValue(reader.GetOrdinal("7코드"))));//7코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY7LEVELNAME", reader.GetValue(reader.GetOrdinal("7코드명"))));//7코드명
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY8LEVELCODE", reader.GetValue(reader.GetOrdinal("8코드"))));//8코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY8LEVELNAME", reader.GetValue(reader.GetOrdinal("8코드명"))));//8코드명
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY9LEVELCODE", reader.GetValue(reader.GetOrdinal("9코드"))));//9코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY9LEVELNAME", reader.GetValue(reader.GetOrdinal("9코드명"))));//9코드명
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY10LEVELCODE ", reader.GetValue(reader.GetOrdinal("10코드"))));//10코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCATEGORY10LEVELNAME ", reader.GetValue(reader.GetOrdinal("10코드명"))));//10코드명
                    insertcommand.Parameters.Add(new OracleParameter(":MDTOID", reader.GetValue(reader.GetOrdinal("담당MD아이디"))));//담당MD아이디
                    insertcommand.Parameters.Add(new OracleParameter(":MDMEMO", reader.GetValue(reader.GetOrdinal("MD메모"))));//MD메모
                    insertcommand.Parameters.Add(new OracleParameter(":BRANDCODE", reader.GetValue(reader.GetOrdinal("브랜드코드"))));//브랜드코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSGROUPCODE", reader.GetValue(reader.GetOrdinal("그룹코드"))));//그룹코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCODE", reader.GetValue(reader.GetOrdinal("상품코드"))));//상품코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSFINALNAME", reader.GetValue(reader.GetOrdinal("상품명"))));//상품명
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSMODEL", reader.GetValue(reader.GetOrdinal("모델명"))));//모델명
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSUNITMOQ", reader.GetValue(reader.GetOrdinal("MOQ(최소판매수량)"))));//MOQ(최소판매수량)
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSDELIVERYORDERDUE", reader.GetValue(reader.GetOrdinal("출고예정일"))));//출고예정일
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSUNITQTY", reader.GetValue(reader.GetOrdinal("내용량"))));//내용량
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSUNIT", reader.GetValue(reader.GetOrdinal("단위코드"))));//단위코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSUNITSUBQTY", reader.GetValue(reader.GetOrdinal("서브내용량"))));//서브내용량
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSSUBUNIT", reader.GetValue(reader.GetOrdinal("서브단위코드"))));//서브단위코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSSPECIAL", reader.GetValue(reader.GetOrdinal("특징"))));//특징
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSFORMAT", reader.GetValue(reader.GetOrdinal("형식"))));//형식
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCAUSE", reader.GetValue(reader.GetOrdinal("주의사항"))));//주의사항
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSSUPPLIES", reader.GetValue(reader.GetOrdinal("용도"))));//용도
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONSUMMARYCODE", reader.GetValue(reader.GetOrdinal("옵션코드"))));//옵션코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION1", reader.GetValue(reader.GetOrdinal("속성명1"))));//속성명1
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES1", reader.GetValue(reader.GetOrdinal("속성값1"))));//속성값1
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION2", reader.GetValue(reader.GetOrdinal("속성명2"))));//속성명2
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES2", reader.GetValue(reader.GetOrdinal("속성값2"))));//속성값2
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION3", reader.GetValue(reader.GetOrdinal("속성명3"))));//속성명3
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES3", reader.GetValue(reader.GetOrdinal("속성값3"))));//속성값3
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION4", reader.GetValue(reader.GetOrdinal("속성명4"))));//속성명4
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES4", reader.GetValue(reader.GetOrdinal("속성값4"))));//속성값4
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION5", reader.GetValue(reader.GetOrdinal("속성명5"))));//속성명5
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES5", reader.GetValue(reader.GetOrdinal("속성값5"))));//속성값5
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION6", reader.GetValue(reader.GetOrdinal("속성명6"))));//속성명6
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES6", reader.GetValue(reader.GetOrdinal("속성값6"))));//속성값6
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION7", reader.GetValue(reader.GetOrdinal("속성명7"))));//속성명7
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES7", reader.GetValue(reader.GetOrdinal("속성값7"))));//속성값7
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION8", reader.GetValue(reader.GetOrdinal("속성명8"))));//속성명8
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES8", reader.GetValue(reader.GetOrdinal("속성값8"))));//속성값8
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION9", reader.GetValue(reader.GetOrdinal("속성명9"))));//속성명9
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES9", reader.GetValue(reader.GetOrdinal("속성값9"))));//속성값9
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION10", reader.GetValue(reader.GetOrdinal("속성명10"))));//속성명10
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES10", reader.GetValue(reader.GetOrdinal("속성값10"))));//속성값10
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION11", reader.GetValue(reader.GetOrdinal("속성명11"))));//속성명11
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES11", reader.GetValue(reader.GetOrdinal("속성값11"))));//속성값11
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION12", reader.GetValue(reader.GetOrdinal("속성명12"))));//속성명12
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES12", reader.GetValue(reader.GetOrdinal("속성값12"))));//속성값12
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION13", reader.GetValue(reader.GetOrdinal("속성명13"))));//속성명13
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES13", reader.GetValue(reader.GetOrdinal("속성값13"))));//속성값13
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION14", reader.GetValue(reader.GetOrdinal("속성명14"))));//속성명14
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES14", reader.GetValue(reader.GetOrdinal("속성값14"))));//속성값14
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION15", reader.GetValue(reader.GetOrdinal("속성명15"))));//속성명15
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES15", reader.GetValue(reader.GetOrdinal("속성값15"))));//속성값15
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION16", reader.GetValue(reader.GetOrdinal("속성명16"))));//속성명16
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES16", reader.GetValue(reader.GetOrdinal("속성값16"))));//속성값16
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION17", reader.GetValue(reader.GetOrdinal("속성명17"))));//속성명17
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES17", reader.GetValue(reader.GetOrdinal("속성값17"))));//속성값17
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION18", reader.GetValue(reader.GetOrdinal("속성명18"))));//속성명18
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES18", reader.GetValue(reader.GetOrdinal("속성값18"))));//속성값18
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION19", reader.GetValue(reader.GetOrdinal("속성명19"))));//속성명19
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES19", reader.GetValue(reader.GetOrdinal("속성값19"))));//속성값19
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONCATION20", reader.GetValue(reader.GetOrdinal("속성명20"))));//속성명20
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSOPTIONVALUES20", reader.GetValue(reader.GetOrdinal("속성값20"))));//속성값20
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSREMINDSEARCH", reader.GetValue(reader.GetOrdinal("연관검색어"))));//연관검색어
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSALIKESEARCH", reader.GetValue(reader.GetOrdinal("관련상품설정"))));//관련상품설정
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSMDSEQ", reader.GetValue(reader.GetOrdinal("상품전시우선순위"))));//상품전시우선순위
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSDISPLAYFLAG", reader.GetValue(reader.GetOrdinal("상품노출여부"))));//상품노출여부
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSNODISPLYREASON", reader.GetValue(reader.GetOrdinal("비노출사유"))));//비노출사유
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSNOSALEREASON", reader.GetValue(reader.GetOrdinal("판매중단사유"))));//판매중단사유
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSNOSALEENTERTARGETDUE", reader.GetValue(reader.GetOrdinal("품절품목입고예정일"))));//품절품목입고예정일
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSRETURNCHANGEFLAG", reader.GetValue(reader.GetOrdinal("반품(교환)불가여부"))));//반품(교환)불가여부
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSKEEPYN", reader.GetValue(reader.GetOrdinal("재고관리여부"))));//재고관리여부
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSSALETAXYN", reader.GetValue(reader.GetOrdinal("판매과세여부"))));//판매과세여부
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSDCYN", reader.GetValue(reader.GetOrdinal("추가DC적용여부"))));//추가DC적용여부
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCUSTGUBUN", reader.GetValue(reader.GetOrdinal("고객사상품구분"))));//고객사상품구분
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSSALECUSTGUBUNCODE", reader.GetValue(reader.GetOrdinal("특정판매고객사코드"))));//특정판매고객사코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSBUYPRICE", reader.GetValue(reader.GetOrdinal("매입가격(VAT별도)"))));//매입가격(VAT별도) 
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSBUYPRICEVAT", reader.GetValue(reader.GetOrdinal("매입가격(VAT포함)"))));//매입가격(VAT포함) 
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCUSTPRICE", reader.GetValue(reader.GetOrdinal("판매사가격(VAT별도)"))));//판매사가격(VAT별도)
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCUSTPRICEVAT", reader.GetValue(reader.GetOrdinal("판매사가격(VAT포함)"))));//판매사가격(VAT포함)
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSSALEPRICE", reader.GetValue(reader.GetOrdinal("구매사판매가격(VAT별도)"))));//구매사판매가격(VAT별도)
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSSALEPRICEVAT", reader.GetValue(reader.GetOrdinal("구매사판매가격(VAT포함)"))));//구매사판매가격(VAT포함)
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSMSALEPRICE", reader.GetValue(reader.GetOrdinal("민간구매사판매가격(VAT별도)"))));//민간구매사판매가격(VAT별도)
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSMSALEPRICEVAT", reader.GetValue(reader.GetOrdinal("민간구매사판매가격(VAT포함)"))));//민간구매사판매가격(VAT포함)
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYBUYGOODSTYPE", reader.GetValue(reader.GetOrdinal("매입상품유형"))));//매입상품유형
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYGOODSUNIT", reader.GetValue(reader.GetOrdinal("공급사단위코드"))));//공급사단위코드
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYGOODSDISTRADMIN", reader.GetValue(reader.GetOrdinal("상품유통기간관리여부"))));//상품유통기간관리여부
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSORIGINCODE", reader.GetValue(reader.GetOrdinal("원산지코드"))));//원산지코드
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSSUPPLYCBARCODE1", reader.GetValue(reader.GetOrdinal("상품바코드(낱개)"))));//상품바코드(낱개)
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSSUPPLYCBARCODE2", reader.GetValue(reader.GetOrdinal("상품바코드(inbox)"))));//상품바코드(inbox)
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSSUPPLYCBARCODE3", reader.GetValue(reader.GetOrdinal("상품바코드(outbox)"))));//상품바코드(outbox)
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSCONFIRMMARK", reader.GetValue(reader.GetOrdinal("상품인증구분"))));//상품인증구분
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYCOMPANYCODE1", reader.GetValue(reader.GetOrdinal("공급사코드1"))));//공급사코드1
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYGOODSCODE1", reader.GetValue(reader.GetOrdinal("공급사상품코드1"))));//공급사상품코드1
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSSUPPLYBARCODE", reader.GetValue(reader.GetOrdinal("상품바코드1"))));//상품바코드1
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYGOODSUNITMOQ", reader.GetValue(reader.GetOrdinal("매입MOQ1"))));//매입MOQ1
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYGOODSENTERDUE", reader.GetValue(reader.GetOrdinal("입고LEADTIME1"))));//입고LEADTIME1
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYBUYCALC", reader.GetValue(reader.GetOrdinal("매입정산구분1"))));//매입정산구분1
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYORDERFORM", reader.GetValue(reader.GetOrdinal("발주형태1"))));//발주형태1
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYTRANSCOSTYN", reader.GetValue(reader.GetOrdinal("매입운송비유무1"))));//매입운송비유무1
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYTRANSCOSTVAT", reader.GetValue(reader.GetOrdinal("매입운송비용1"))));//매입운송비용1
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYGOODSDISTRDUE", reader.GetValue(reader.GetOrdinal("상품제조유통기간1"))));//상품제조유통기간1
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYCOMPANYCODE2", reader.GetValue(reader.GetOrdinal("공급사코드2"))));//공급사코드2
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYGOODSCODE2", reader.GetValue(reader.GetOrdinal("공급사상품코드2"))));//공급사상품코드2
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSSUPPLYBARCODE2", reader.GetValue(reader.GetOrdinal("상품바코드2"))));//상품바코드2
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYGOODSUNITMOQ2", reader.GetValue(reader.GetOrdinal("매입MOQ2"))));//매입MOQ2
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYGOODSENTERDUE2", reader.GetValue(reader.GetOrdinal("입고LEADTIME2"))));//입고LEADTIME2
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYBUYCALC2", reader.GetValue(reader.GetOrdinal("매입정산구분2"))));//매입정산구분2
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYORDERFORM2", reader.GetValue(reader.GetOrdinal("발주형태2"))));//발주형태2
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYTRANSCOSTYN2", reader.GetValue(reader.GetOrdinal("매입운송비유무2"))));//매입운송비유무2
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYTRANSCOSTVAT2", reader.GetValue(reader.GetOrdinal("매입운송비용2"))));//매입운송비용2
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYGOODSDISTRDUE2", reader.GetValue(reader.GetOrdinal("상품제조유통기간2"))));//상품제조유통기간2
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYCOMPANYCODE3", reader.GetValue(reader.GetOrdinal("공급사코드3"))));//공급사코드3
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYGOODSCODE3", reader.GetValue(reader.GetOrdinal("공급사상품코드3"))));//공급사상품코드3
                    insertcommand.Parameters.Add(new OracleParameter(":GOODSSUPPLYBARCODE3", reader.GetValue(reader.GetOrdinal("상품바코드3"))));//상품바코드3
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYGOODSUNITMOQ3", reader.GetValue(reader.GetOrdinal("매입MOQ3"))));//매입MOQ3
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYGOODSENTERDUE3", reader.GetValue(reader.GetOrdinal("입고LEADTIME3"))));//입고LEADTIME3
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYBUYCALC3", reader.GetValue(reader.GetOrdinal("매입정산구분3"))));//매입정산구분3
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYORDERFORM3", reader.GetValue(reader.GetOrdinal("발주형태3"))));//발주형태3
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYTRANSCOSTYN3", reader.GetValue(reader.GetOrdinal("매입운송비유무3"))));//매입운송비유무3
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYTRANSCOSTVAT3", reader.GetValue(reader.GetOrdinal("매입운송비용3"))));//매입운송비용3
                    insertcommand.Parameters.Add(new OracleParameter(":SUPPLYGOODSDISTRDUE3", reader.GetValue(reader.GetOrdinal("상품제조유통기간3"))));//상품제조유통기간3
                    insertcommand.Parameters.Add(new OracleParameter(":DELIVERYGUBUN", reader.GetValue(reader.GetOrdinal("배송구분"))));//배송구분
                    insertcommand.Parameters.Add(new OracleParameter(":DELIVERYCOSTGUBUN", reader.GetValue(reader.GetOrdinal("배송비구분"))));//배송비구분
                    insertcommand.Parameters.Add(new OracleParameter(":DELIVERYCOST_CODE", reader.GetValue(reader.GetOrdinal("배송비 비용코드"))));//배송비 비용코드

                    insertcommand.ExecuteNonQuery();

                }
                trans.Commit();   //커밋

            }
        }

    }

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
        string query = "SELECT * FROM [합본$] WHERE [상품코드] IS NOT NULL";
        OleDbDataAdapter daexcel = new OleDbDataAdapter(query, conn);
        dtexcel.Locale = CultureInfo.CurrentCulture;
        daexcel.Fill(dtexcel);
        conn.Close();
        
        return dtexcel;

    }


    //public void WriteToServer(string connectionString, string qualifiedDBName, DataTable dataTable)
    //{
    //    using (var connection = new OracleConnection(connectionString))
    //    {
    //        connection.Open();
    //        using (var bulkCopy = new OracleBulkCopy(connection, OracleBulkCopyOptions.UseInternalTransaction))
    //        {
    //            bulkCopy.DestinationTableName = qualifiedDBName;
    //            bulkCopy.BatchSize = 1000;
    //            bulkCopy.ColumnMappings.Add("최종카테고리", "GOODSCATEGORYFINALCODE");
    //            bulkCopy.ColumnMappings.Add("상위카테고리 코드", "GOODSCATEGORYUPCODE");
    //            bulkCopy.ColumnMappings.Add("최종카테고리명", "GOODSCATEGORYFINALNAME");
    //            bulkCopy.ColumnMappings.Add("카테고리1단코드", "GOODSCATEGORY1LEVELCODE");
    //            bulkCopy.ColumnMappings.Add("카테고리1단명", "GOODSCATEGORY1LEVELNAME");
    //            bulkCopy.ColumnMappings.Add("카테고리2단코드", "GOODSCATEGORY2LEVELCODE");
    //            bulkCopy.ColumnMappings.Add("카테고리2단명", "GOODSCATEGORY2LEVELNAME");
    //            bulkCopy.ColumnMappings.Add("카테고리3단코드", "GOODSCATEGORY3LEVELCODE");
    //            bulkCopy.ColumnMappings.Add("카테고리3단명", "GOODSCATEGORY3LEVELNAME");
    //            bulkCopy.ColumnMappings.Add("카테고리4단코드", "GOODSCATEGORY4LEVELCODE");
    //            bulkCopy.ColumnMappings.Add("카테고리4단명", "GOODSCATEGORY4LEVELNAME");
    //            bulkCopy.ColumnMappings.Add("카테고리5단코드", "GOODSCATEGORY5LEVELCODE");
    //            bulkCopy.ColumnMappings.Add("카테고리5단명", "GOODSCATEGORY5LEVELNAME");
    //            bulkCopy.ColumnMappings.Add("담당MD아이디", "MDTOID");
    //            bulkCopy.ColumnMappings.Add("MD메모", "MDMEMO");
    //            bulkCopy.ColumnMappings.Add("브랜드코드", "BRANDCODE");
    //            bulkCopy.ColumnMappings.Add("그룹코드", "GOODSGROUPCODE");
    //            bulkCopy.ColumnMappings.Add("상품코드", "GOODSCODE");
    //            bulkCopy.ColumnMappings.Add("상품명", "GOODSFINALNAME");
    //            bulkCopy.ColumnMappings.Add("모델명", "GOODSMODEL");
    //            bulkCopy.ColumnMappings.Add("MOQ(최소판매수량)", "GOODSUNITMOQ");
    //            bulkCopy.ColumnMappings.Add("출고예정일", "GOODSDELIVERYORDERDUE");
    //            bulkCopy.ColumnMappings.Add("내용량", "GOODSUNITQTY");
    //            bulkCopy.ColumnMappings.Add("단위코드", "GOODSUNIT");
    //            bulkCopy.ColumnMappings.Add("서브내용량", "GOODSUNITSUBQTY");
    //            bulkCopy.ColumnMappings.Add("서브단위코드", "GOODSSUBUNIT");
    //            bulkCopy.ColumnMappings.Add("특징", "GOODSSPECIAL");
    //            bulkCopy.ColumnMappings.Add("형식", "GOODSFORMAT");
    //            bulkCopy.ColumnMappings.Add("주의사항", "GOODSCAUSE");
    //            bulkCopy.ColumnMappings.Add("용도", "GOODSSUPPLIES");
    //            bulkCopy.ColumnMappings.Add("옵션코드", "GOODSOPTIONSUMMARYCODE");
    //            bulkCopy.ColumnMappings.Add("속성명1", "GOODSOPTIONCATION1");
    //            bulkCopy.ColumnMappings.Add("속성값1", "GOODSOPTIONVALUES1");
    //            bulkCopy.ColumnMappings.Add("속성명2", "GOODSOPTIONCATION2");
    //            bulkCopy.ColumnMappings.Add("속성값2", "GOODSOPTIONVALUES2");
    //            bulkCopy.ColumnMappings.Add("속성명3", "GOODSOPTIONCATION3");
    //            bulkCopy.ColumnMappings.Add("속성값3", "GOODSOPTIONVALUES3");
    //            bulkCopy.ColumnMappings.Add("속성명4", "GOODSOPTIONCATION4");
    //            bulkCopy.ColumnMappings.Add("속성값4", "GOODSOPTIONVALUES4");
    //            bulkCopy.ColumnMappings.Add("속성명5", "GOODSOPTIONCATION5");
    //            bulkCopy.ColumnMappings.Add("속성값5", "GOODSOPTIONVALUES5");
    //            bulkCopy.ColumnMappings.Add("속성명6", "GOODSOPTIONCATION6");
    //            bulkCopy.ColumnMappings.Add("속성값6", "GOODSOPTIONVALUES6");
    //            bulkCopy.ColumnMappings.Add("속성명7", "GOODSOPTIONCATION7");
    //            bulkCopy.ColumnMappings.Add("속성값7", "GOODSOPTIONVALUES7");
    //            bulkCopy.ColumnMappings.Add("속성명8", "GOODSOPTIONCATION8");
    //            bulkCopy.ColumnMappings.Add("속성값8", "GOODSOPTIONVALUES8");
    //            bulkCopy.ColumnMappings.Add("속성명9", "GOODSOPTIONCATION9");
    //            bulkCopy.ColumnMappings.Add("속성값9", "GOODSOPTIONVALUES9");
    //            bulkCopy.ColumnMappings.Add("속성명10", "GOODSOPTIONCATION10");
    //            bulkCopy.ColumnMappings.Add("속성값10", "GOODSOPTIONVALUES10");
    //            bulkCopy.ColumnMappings.Add("속성명11", "GOODSOPTIONCATION11");
    //            bulkCopy.ColumnMappings.Add("속성값11", "GOODSOPTIONVALUES11");
    //            bulkCopy.ColumnMappings.Add("속성명12", "GOODSOPTIONCATION12");
    //            bulkCopy.ColumnMappings.Add("속성값12", "GOODSOPTIONVALUES12");
    //            bulkCopy.ColumnMappings.Add("속성명13", "GOODSOPTIONCATION13");
    //            bulkCopy.ColumnMappings.Add("속성값13", "GOODSOPTIONVALUES13");
    //            bulkCopy.ColumnMappings.Add("속성명14", "GOODSOPTIONCATION14");
    //            bulkCopy.ColumnMappings.Add("속성값14", "GOODSOPTIONVALUES14");
    //            bulkCopy.ColumnMappings.Add("속성명15", "GOODSOPTIONCATION15");
    //            bulkCopy.ColumnMappings.Add("속성값15", "GOODSOPTIONVALUES15");
    //            bulkCopy.ColumnMappings.Add("속성명16", "GOODSOPTIONCATION16");
    //            bulkCopy.ColumnMappings.Add("속성값16", "GOODSOPTIONVALUES16");
    //            bulkCopy.ColumnMappings.Add("속성명17", "GOODSOPTIONCATION17");
    //            bulkCopy.ColumnMappings.Add("속성값17", "GOODSOPTIONVALUES17");
    //            bulkCopy.ColumnMappings.Add("속성명18", "GOODSOPTIONCATION18");
    //            bulkCopy.ColumnMappings.Add("속성값18", "GOODSOPTIONVALUES18");
    //            bulkCopy.ColumnMappings.Add("속성명19", "GOODSOPTIONCATION19");
    //            bulkCopy.ColumnMappings.Add("속성값19", "GOODSOPTIONVALUES19");
    //            bulkCopy.ColumnMappings.Add("속성명20", "GOODSOPTIONCATION20");
    //            bulkCopy.ColumnMappings.Add("속성값20", "GOODSOPTIONVALUES20");
    //            bulkCopy.ColumnMappings.Add("연관검색어", "GOODSREMINDSEARCH");
    //            bulkCopy.ColumnMappings.Add("상품노출여부", "GOODSDISPLAYFLAG");
    //            bulkCopy.ColumnMappings.Add("비노출사유", "GOODSNODISPLYREASON");
    //            bulkCopy.ColumnMappings.Add("판매중단사유", "GOODSNOSALEREASON");
    //            bulkCopy.ColumnMappings.Add("품절품목입고예정일", "GOODSNOSALEENTERTARGETDUE");
    //            bulkCopy.ColumnMappings.Add("반품(교환)불가여부", "GOODSRETURNCHANGEFLAG");
    //            bulkCopy.ColumnMappings.Add("재고관리여부", "GOODSKEEPYN");
    //            bulkCopy.ColumnMappings.Add("판매과세여부", "GOODSSALETAXYN");
    //            bulkCopy.ColumnMappings.Add("추가DC적용여부", "GOODSDCYN");
    //            bulkCopy.ColumnMappings.Add("고객사상품구분", "GOODSCUSTGUBUN");
    //            bulkCopy.ColumnMappings.Add("특정판매고객사코드", "GOODSSALECUSTGUBUNCODE");
    //            bulkCopy.ColumnMappings.Add("매입가격(VAT별도)", "GOODSBUYPRICE");
    //            bulkCopy.ColumnMappings.Add("매입가격(VAT포함)", "GOODSBUYPRICEVAT");
    //            bulkCopy.ColumnMappings.Add("판매사가격(VAT별도)", "GOODSCUSTPRICE");
    //            bulkCopy.ColumnMappings.Add("판매사가격(VAT포함)", "GOODSCUSTPRICEVAT");
    //            bulkCopy.ColumnMappings.Add("구매사판매가격(VAT별도)", "GOODSSALEPRICE");
    //            bulkCopy.ColumnMappings.Add("구매사판매가격(VAT포함)", "GOODSSALEPRICEVAT");
    //            bulkCopy.ColumnMappings.Add("민간구매사판매가격(VAT별도)", "GOODSMSALEPRICE");
    //            bulkCopy.ColumnMappings.Add("민간구매사판매가격(VAT포함)", "GOODSMSALEPRICEVAT");
    //            bulkCopy.ColumnMappings.Add("매입상품유형", "SUPPLYBUYGOODSTYPE");
    //            bulkCopy.ColumnMappings.Add("공급사단위코드", "SUPPLYGOODSUNIT");
    //            bulkCopy.ColumnMappings.Add("상품유통기간관리여부", "SUPPLYGOODSDISTRADMIN");
    //            bulkCopy.ColumnMappings.Add("원산지코드", "GOODSORIGINCODE");
    //            bulkCopy.ColumnMappings.Add("상품바코드(낱개)", "GOODSSUPPLYCBARCODE1");
    //            bulkCopy.ColumnMappings.Add("상품바코드(inbox)", "GOODSSUPPLYCBARCODE2");
    //            bulkCopy.ColumnMappings.Add("상품바코드(outbox)", "GOODSSUPPLYCBARCODE3");
    //            bulkCopy.ColumnMappings.Add("상품인증구분", "GOODSCONFIRMMARK");
    //            bulkCopy.ColumnMappings.Add("공급사코드1", "SUPPLYCOMPANYCODE1");
    //            bulkCopy.ColumnMappings.Add("공급사상품코드1", "SUPPLYGOODSCODE1");
    //            bulkCopy.ColumnMappings.Add("상품바코드1", "GOODSSUPPLYBARCODE");
    //            bulkCopy.ColumnMappings.Add("매입MOQ1", "SUPPLYGOODSUNITMOQ");
    //            bulkCopy.ColumnMappings.Add("입고LEADTIME1", "SUPPLYGOODSENTERDUE");
    //            bulkCopy.ColumnMappings.Add("매입정산구분1", "SUPPLYBUYCALC");
    //            bulkCopy.ColumnMappings.Add("발주형태1", "SUPPLYORDERFORM");
    //            bulkCopy.ColumnMappings.Add("매입운송비유무1", "SUPPLYTRANSCOSTYN");
    //            bulkCopy.ColumnMappings.Add("매입운송비용1", "SUPPLYTRANSCOSTVAT");
    //            bulkCopy.ColumnMappings.Add("상품제조유통기간1", "SUPPLYGOODSDISTRDUE");
    //            bulkCopy.ColumnMappings.Add("공급사코드2", "SUPPLYCOMPANYCODE2");
    //            bulkCopy.ColumnMappings.Add("공급사상품코드2", "SUPPLYGOODSCODE2");
    //            bulkCopy.ColumnMappings.Add("상품바코드2", "GOODSSUPPLYBARCODE2");
    //            bulkCopy.ColumnMappings.Add("매입MOQ2", "SUPPLYGOODSUNITMOQ2");
    //            bulkCopy.ColumnMappings.Add("입고LEADTIME2", "SUPPLYGOODSENTERDUE2");
    //            bulkCopy.ColumnMappings.Add("매입정산구분2", "SUPPLYBUYCALC2");
    //            bulkCopy.ColumnMappings.Add("발주형태2", "SUPPLYORDERFORM2");
    //            bulkCopy.ColumnMappings.Add("매입운송비유무2", "SUPPLYTRANSCOSTYN2");
    //            bulkCopy.ColumnMappings.Add("매입운송비용2", "SUPPLYTRANSCOSTVAT2");
    //            bulkCopy.ColumnMappings.Add("상품제조유통기간2", "SUPPLYGOODSDISTRDUE2");
    //            bulkCopy.ColumnMappings.Add("공급사코드3", "SUPPLYCOMPANYCODE3");
    //            bulkCopy.ColumnMappings.Add("공급사상품코드3", "SUPPLYGOODSCODE3");
    //            bulkCopy.ColumnMappings.Add("상품바코드3", "GOODSSUPPLYBARCODE3");
    //            bulkCopy.ColumnMappings.Add("매입MOQ3", "SUPPLYGOODSUNITMOQ3");
    //            bulkCopy.ColumnMappings.Add("입고LEADTIME3", "SUPPLYGOODSENTERDUE3");
    //            bulkCopy.ColumnMappings.Add("매입정산구분3", "SUPPLYBUYCALC3");
    //            bulkCopy.ColumnMappings.Add("발주형태3", "SUPPLYORDERFORM3");
    //            bulkCopy.ColumnMappings.Add("매입운송비유무3", "SUPPLYTRANSCOSTYN3");
    //            bulkCopy.ColumnMappings.Add("매입운송비용3", "SUPPLYTRANSCOSTVAT3");
    //            bulkCopy.ColumnMappings.Add("상품제조유통기간3", "SUPPLYGOODSDISTRDUE3");
    //            bulkCopy.ColumnMappings.Add("배송구분", "DELIVERYGUBUN");
    //            bulkCopy.ColumnMappings.Add("배송비구분", "DELIVERYCOSTGUBUN");
    //            bulkCopy.ColumnMappings.Add("배송비 비용코드", "DELIVERYCOST_CODE");

    //            try
    //            {
    //                bulkCopy.WriteToServer(dataTable);
    //            }
    //            catch (Exception ex)
    //            {
    //                logger.ErrorFormat("GoodsImsi WriteToServer Error Msg={0}", ex);
    //                throw;
    //            }
    //            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('업로드 완료 되었습니다. 웹전시 버튼을 클릭해야 데이터가 업로드 완료됩니다. ');</script>");
    //        }
    //    }
    //}
    
    public void ExportExcel(string goodsCodes)
    {
        ExcelService excelService = new ExcelService();
        var paramList = new Dictionary<string, object>() {
              {"nvar_P_GOODSCODES", goodsCodes}

        };
        string fileName = Server.UrlEncode("우리안 신규상품 업로드");

        var reader = excelService.GetAdminGoodsListAfterInsertExcelReader(paramList);
        string[] headerNames = { "상품코드", "상품명", "모델명", "옵션코드"};
       

        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("합본");

            int headerIndex = 0;

            foreach (string name in headerNames)
            {

                ws.Cells[1, headerIndex + 1].Value = name;
                headerIndex++;

            }

            int count = reader.FieldCount;
            int col = 1, row = 2;
            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    for (int i = 0; i < count; i++)
                    {
                        var val = reader.GetValue(i);
                        ws.SetValue(row, col++, val);
                    }
                    row++;
                    col = 1;
                }
                //Format the header
                using (ExcelRange rng = ws.Cells[1, 1, 1, count])
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
                using (ExcelRange rng = ws.Cells[2, 1, row - 1, count])
                {
                    rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

                }

                ws.Cells[2, 4, row, 4].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                //셀 사이즈 오토 세팅
                using (ExcelRange rng = ws.Cells[1, 1, row - 1, count])
                {
                    rng.AutoFitColumns();
                }

                //Write it back to the client
                HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                HttpContext.Current.Response.AddHeader("content-disposition", "attachment;  filename=" + fileName + ".xlsx");
                HttpContext.Current.Response.BinaryWrite(pck.GetAsByteArray());
                HttpContext.Current.Response.Flush();
                HttpContext.Current.Response.SuppressContent = true;
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
            
        }
    }

    protected void btnWebTransfer_Click(object sender, EventArgs e)
    {
        logger.Debug("웹전시 Start!!!");
        GoodsService goodsService = new GoodsService();
        string returnVal = string.Empty;
        var param = new Dictionary<string, object> {

            { "reVa_P_RETURN", ""},
        };

        try
        {
            returnVal = goodsService.WebGoodsInsert(param);

        }
        catch (Exception ex)
        {

            logger.Error(ex, "GoodsImsi WriteToServer Error Msg");
            throw;
        }
        if (returnVal == "2")
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('상품등록중에 옵션코드와 단위코드가 문제가 있어 중지되었습니다. 관리자에게 문의 주시기 바랍니다.');</script>");

        }
        else
        {
            try
            {
                logger.Debug("웹전시 GoodsCodeList={0}", returnVal);
                ExportExcel(returnVal);
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Web전시 ExportExcel 에러");
                throw;
            }
        }
    }

    

    

    
} 