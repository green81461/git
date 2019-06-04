using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using SocialWith.Biz.Category;
using System.Data.OleDb;
//using Oracle.DataAccess.Client;
using SocialWith.Biz.Excel;
using Oracle.ManagedDataAccess.Client;
using System.Data;

public partial class Admin_Goods_GoodsModify : AdminPageBase
{
    protected string GoodsCode;
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        if (!IsPostBack)
        {
            DefaultDataBind();
        }
    }

    protected void ParseRequestParameters()
    {
        GoodsCode = Request.QueryString["GoodsCode"].AsText();
    }

    protected void DefaultDataBind()
    {

    }

    protected void btnImgSave_Click(object sender, EventArgs e)
    {
        try
        {
            string ctgrCode = hfCtgrCode.Value;
            string groupCode = hfGroupCode.Value;
            if (string.IsNullOrWhiteSpace(GoodsCode))
            {
                GoodsCode = hfGoodsCode.Value;
            }
            string fileName1 = ctgrCode + "-" + groupCode + "-" + GoodsCode + "-fff.jpg";
            string fileName2 = ctgrCode + "-" + groupCode + "-" + GoodsCode + "-mmm.jpg";
            string fileName3 = ctgrCode + "-" + groupCode + "-" + GoodsCode + "-sss.jpg";
            string fileName4 = ctgrCode + "-" + groupCode + "-" + GoodsCode + "-ddd1.jpg";
            string fileName5 = ctgrCode + "-" + groupCode + "-" + GoodsCode + "-ddd2.jpg";
            string fileName6 = ctgrCode + "-" + groupCode + "-" + GoodsCode + "-ddd3.jpg";
            string fileName7 = ctgrCode + "-" + groupCode + "-" + GoodsCode + "-ddd4.jpg";
            //string path = String.Format("{0}/{1}/{2}/{3}/{4}/"
            //                                          , ConfigurationManager.AppSettings["UpLoadFolder"]
            //                                          , "Goods"
            //                                          , ctgrCode
            //                                          , groupCode
            //                                          , GoodsCode);

            string path = @"D:\GoodsImage\" + ctgrCode + @"\" + groupCode + @"\" + GoodsCode + @"\";

            //FileHelper.CreateDirectory(Server.MapPath(path));
            FileHelper.CreateDirectory(path);
            logger.Debug("path="+ path);


            //string realPath1 = Server.MapPath(path + fileName1);
            string realPath1 = path + fileName1;

            if (fuFile_1.HasFile)
            {
                if (File.Exists(realPath1))
                {
                    File.Delete(realPath1);
                    fuFile_1.SaveAs(realPath1);
                }
                else
                {
                    fuFile_1.SaveAs(realPath1);
                }
            }
            //string realPath2 = Server.MapPath(path + fileName2);
            string realPath2 = path + fileName2;
            if (fuFile_2.HasFile)
            {
                if (File.Exists(realPath2))
                {
                    File.Delete(realPath2);
                    fuFile_2.SaveAs(realPath2);
                }
                else
                {
                    fuFile_2.SaveAs(realPath2);
                }
            }
            //string realPath3 = Server.MapPath(path + fileName3);
            string realPath3 = path + fileName3;
            if (fuFile_3.HasFile)
            {
                if (File.Exists(realPath3))
                {
                    File.Delete(realPath3);
                    fuFile_3.SaveAs(realPath3);
                }
                else
                {
                    fuFile_3.SaveAs(realPath3);
                }
            }
            //string realPath4 = Server.MapPath(path + fileName4);
            string realPath4 = path + fileName4;
            if (fuFile_4.HasFile)
            {
                if (File.Exists(realPath4))
                {
                    File.Delete(realPath4);
                    fuFile_4.SaveAs(realPath4);
                }
                else
                {
                    fuFile_4.SaveAs(realPath4);
                }
            }

            //string realPath5 = Server.MapPath(path + fileName5);
            string realPath5 = path + fileName5;
            if (fuFile_5.HasFile)
            {
                if (File.Exists(realPath5))
                {
                    File.Delete(realPath5);
                    fuFile_5.SaveAs(realPath5);
                }
                else
                {
                    fuFile_5.SaveAs(realPath5);
                }
            }

            //string realPath6 = Server.MapPath(path + fileName6);
            string realPath6 =path + fileName6;
            if (fuFile_6.HasFile)
            {
                if (File.Exists(realPath6))
                {
                    File.Delete(realPath6);
                    fuFile_6.SaveAs(realPath6);
                }
                else
                {
                    fuFile_6.SaveAs(realPath6);
                }
            }

            //string realPath7 = Server.MapPath(path + fileName7);
            string realPath7 = path + fileName7;
            if (fuFile_7.HasFile)
            {
                if (File.Exists(realPath7))
                {
                    File.Delete(realPath7);
                    fuFile_7.SaveAs(realPath7);
                }
                else
                {
                    fuFile_7.SaveAs(realPath7);
                }
            }
        }
        catch (Exception ex)
        {
            logger.Error(ex, "상품수정 이미지 파일 업로드 에러 msg");
            throw;
        }

        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('이미지 업로드가 완료되었습니다.');</script>");
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

                string sheetName = "Sheet1";
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
                    var dataCommand = new OleDbCommand("SELECT  * FROM [" + sheetName + "$] WHERE [상품코드] IS NOT NULL", conn);
                    var reader = dataCommand.ExecuteReader();

                    logger.Debug("update시작");
                    UpdateGoods(reader, conn);
                    logger.Debug("update끝");
                }
                ;

            }
            catch (Exception ex)
            {
                logger.Error(ex, "기존상품 업로드 에러 msg");
                throw;
            }
            finally
            {
                fuExcel.PostedFile.InputStream.Dispose();
                string virtualPath = ConfigurationManager.AppSettings["UpLoadFolder"] + "/Temp/";
                string excelPath = Server.MapPath(virtualPath + fuExcel.FileName);
                File.Delete(excelPath);
            }
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('업로드가 완료되었습니다.');</script>");
        }
        else
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('파일을 선택해 주세요.');</script>");
        }
    }

    public void UpdateGoods(OleDbDataReader reader, OleDbConnection conn)
    {

        string createTable = @"CREATE TABLE TEMP_GOODS (
              BRANDCODE                    VARCHAR2(30 BYTE)        NULL,
              GOODSGROUPCODE                    VARCHAR2(16 BYTE)        NULL,
              GOODSCODE                    VARCHAR2(16 BYTE)        NULL,
              GOODSFINALNAME               VARCHAR2(80 BYTE)           NULL,
              GOODSMODEL                   VARCHAR2(200 BYTE)          NULL, 
              GOODSREMINDSEARCH VARCHAR2(4000 BYTE)         NULL, 
              GOODSOPTIONSUMMARYCODE VARCHAR2(1000 BYTE)      NULL,
              GOODSDISPLAYFLAG VARCHAR2(10 BYTE)                   NULL, 
              GOODSNODISPLYREASON VARCHAR2(10 BYTE)               NULL, 
              GOODSNOSALEREASON VARCHAR2(10 BYTE)                NULL, 
              GOODSBUYPRICE VARCHAR2(30 BYTE)             NULL, 
              GOODSBUYPRICEVAT VARCHAR2(30 BYTE)               NULL, 
              GOODSSALEPRICE VARCHAR2(30 BYTE)             NULL, 
              GOODSSALEPRICEVAT VARCHAR2(30 BYTE)             NULL, 
              GOODSMSALEPRICE VARCHAR2(30 BYTE)             NULL, 
              GOODSMSALEPRICEVAT VARCHAR2(30 BYTE)             NULL, 
              GOODSCUSTPRICE VARCHAR2(30 BYTE)            NULL, 
              GOODSCUSTPRICEVAT VARCHAR2(30 BYTE)            NULL, 
              SUPPLYCOMPANYCODE1 VARCHAR2(7 BYTE)         NULL,
              SUPPLYGOODSCODE1             VARCHAR2(20 BYTE)           NULL, 
              SUPPLYGOODSUNITMOQ VARCHAR2(30 BYTE)                  NULL, 
              SUPPLYGOODSENTERDUE VARCHAR2(10 BYTE)               NULL, 
              SUPPLYBUYCALC VARCHAR2(10 BYTE)                NULL, 
              SUPPLYORDERFORM VARCHAR2(10 BYTE)                 NULL, 
              SUPPLYCOMPANYCODE2 VARCHAR2(7 BYTE)            NULL, 
              SUPPLYGOODSCODE2 VARCHAR2(20 BYTE)           NULL, 
              SUPPLYGOODSUNITMOQ2 VARCHAR2(30 BYTE)                NULL, 
              SUPPLYGOODSENTERDUE2 VARCHAR2(30 BYTE)                NULL, 
              SUPPLYBUYCALC2 VARCHAR2(30 BYTE)                 NULL, 
              SUPPLYORDERFORM2 VARCHAR2(30 BYTE)                NULL
              
            
            )";

        string connectionString = ConfigurationManager.AppSettings["ConnectionString"];

        // Connect to the AdventureWorks database.  
        using (OracleConnection connection = new OracleConnection(connectionString))
        {
            connection.Open();
            OracleCommand command = new OracleCommand("", connection);



            string countQuery = @"SELECT COUNT(*)  FROM dba_tables WHERE owner = 'SOCIALW' AND table_name = 'TEMP_GOODS'";
            command.CommandText = countQuery;
            int count = command.ExecuteScalar().AsInt();

            if (count == 0)
            {
                logger.Debug("임시테이블 만들기 시작");
                command.CommandText = createTable;
                command.ExecuteNonQuery();
                logger.Debug("임시테이블 만들기 끝");

                try
                {
                    InsertTempGoods(connection, reader);
                    UpdateMergeGoods(connection);
                }
                catch (Exception ex)
                {
                    string err = "\r\n 에러 발생 원인 : " + ex.Source +
                     "\r\n 에러 메시지    : " + ex.Message +
                     "\r\n Stack Trace    : " + ex.StackTrace.ToString() +
                     "\r\n 내부 오류      : " + ex.InnerException;
                    //lblErrorMsg.Text = err;
                    logger.Error(ex, "기존상품 업로드 에러 msg");
                    throw;
                }
                finally
                {

                    string countQuery2 = @"SELECT COUNT(*)  FROM dba_tables WHERE owner = 'SOCIALW' AND table_name = 'TEMP_GOODS'";
                    command.CommandText = countQuery2;
                    int count2 = command.ExecuteScalar().AsInt();

                    if (count2 > 0)
                    {
                        string dropCommand = "DROP TABLE TEMP_GOODS CASCADE CONSTRAINTS";
                        command.CommandText = dropCommand;
                        command.ExecuteNonQuery();
                    }
                }
            }
            else
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('임시 테이블이 아직 존재합니다. 나중에 다시 시도해 주세요');</script>");
            }

        }
    }


    //임시테이블 Insert
    protected void InsertTempGoods(OracleConnection connection, OleDbDataReader reader)
    {

        using (OracleTransaction trans = connection.BeginTransaction())
        {
            string insertQuery = @"INSERT INTO TEMP_GOODS
                                   (
                                          BRANDCODE,
                                          GOODSGROUPCODE,
                                          GOODSCODE,
                                          GOODSFINALNAME,
                                          GOODSMODEL,
                                          GOODSREMINDSEARCH,
                                          GOODSOPTIONSUMMARYCODE,
                                          GOODSDISPLAYFLAG,
                                          GOODSNODISPLYREASON,
                                          GOODSNOSALEREASON,
                                          GOODSBUYPRICE,
                                          GOODSBUYPRICEVAT,
                                          GOODSSALEPRICE,
                                          GOODSSALEPRICEVAT,
                                          GOODSCUSTPRICE,
                                          GOODSCUSTPRICEVAT,
                                          GOODSMSALEPRICE,
                                          GOODSMSALEPRICEVAT,
                                          SUPPLYCOMPANYCODE1,
                                          SUPPLYGOODSCODE1,
                                          SUPPLYGOODSUNITMOQ,
                                          SUPPLYGOODSENTERDUE,
                                          SUPPLYBUYCALC,
                                          SUPPLYORDERFORM,
                                          SUPPLYCOMPANYCODE2,
                                          SUPPLYGOODSCODE2,
                                          SUPPLYGOODSUNITMOQ2,
                                          SUPPLYGOODSENTERDUE2,
                                          SUPPLYBUYCALC2,
                                          SUPPLYORDERFORM2
                                   )
                                   VALUES
                                   (
                                          :BRANDCODE,
                                          :GOODSGROUPCODE,
                                          :GOODSCODE,
                                          :GOODSFINALNAME,
                                          :GOODSMODEL,
                                          :GOODSREMINDSEARCH,
                                          :GOODSOPTIONSUMMARYCODE,
                                          :GOODSDISPLAYFLAG,
                                          :GOODSNODISPLYREASON,
                                          :GOODSNOSALEREASON,
                                          :GOODSBUYPRICE,
                                          :GOODSBUYPRICEVAT,
                                          :GOODSSALEPRICE,
                                          :GOODSSALEPRICEVAT,
                                          :GOODSCUSTPRICE,
                                          :GOODSCUSTPRICEVAT,
                                          :GOODSMSALEPRICE,
                                          :GOODSMSALEPRICEVAT,
                                          :SUPPLYCOMPANYCODE1,
                                          :SUPPLYGOODSCODE1,
                                          :SUPPLYGOODSUNITMOQ,
                                          :SUPPLYGOODSENTERDUE,
                                          :SUPPLYBUYCALC,
                                          :SUPPLYORDERFORM,
                                          :SUPPLYCOMPANYCODE2,
                                          :SUPPLYGOODSCODE2,
                                          :SUPPLYGOODSUNITMOQ2,
                                          :SUPPLYGOODSENTERDUE2,
                                          :SUPPLYBUYCALC2,
                                          :SUPPLYORDERFORM2
                                          
                                   )";

            if (reader.HasRows)
            {
                logger.Debug("임시테이블 데이터 넣기 시작");
                while (reader.Read())
                {


                    OracleCommand insertcommand = new OracleCommand(insertQuery, connection);
                    //insertcommand.Transaction = transaction;
                    insertcommand.CommandType = CommandType.Text;

                    insertcommand.Parameters.Add(new OracleParameter("BRANDCODE", reader.GetValue(reader.GetOrdinal("브랜드코드"))));//브랜드코드
                    insertcommand.Parameters.Add(new OracleParameter("GOODSGROUPCODE", reader.GetValue(reader.GetOrdinal("그룹코드"))));//그룹코드
                    insertcommand.Parameters.Add(new OracleParameter("GOODSCODE", reader.GetValue(reader.GetOrdinal("상품코드"))));//상품코드
                    insertcommand.Parameters.Add(new OracleParameter("GOODSFINALNAME", reader.GetValue(reader.GetOrdinal("상품명"))));//상품명
                    insertcommand.Parameters.Add(new OracleParameter("GOODSMODEL", reader.GetValue(reader.GetOrdinal("모델명"))));//모델명
                    insertcommand.Parameters.Add(new OracleParameter("GOODSREMINDSEARCH", reader.GetValue(reader.GetOrdinal("연관검색어"))));//연관검색어
                    insertcommand.Parameters.Add(new OracleParameter("GOODSOPTIONSUMMARYCODE", reader.GetValue(reader.GetOrdinal("옵션코드"))));//옵션코드
                    insertcommand.Parameters.Add(new OracleParameter("GOODSDISPLAYFLAG", reader.GetValue(reader.GetOrdinal("상품노출여부"))));//상품노출여부
                    insertcommand.Parameters.Add(new OracleParameter("GOODSNODISPLYREASON", reader.GetValue(reader.GetOrdinal("비노출사유"))));//비노출사유
                    insertcommand.Parameters.Add(new OracleParameter("GOODSNOSALEREASON", reader.GetValue(reader.GetOrdinal("판매중단사유"))));//판매중단사유
                    insertcommand.Parameters.Add(new OracleParameter("GOODSBUYPRICE", reader.GetValue(reader.GetOrdinal("매입가격(VAT별도)"))));//매입가격(VAT별도)
                    insertcommand.Parameters.Add(new OracleParameter("GOODSBUYPRICEVAT", reader.GetValue(reader.GetOrdinal("매입가격(VAT포함)"))));//매입가격(VAT포함)
                    insertcommand.Parameters.Add(new OracleParameter("GOODSSALEPRICE", reader.GetValue(reader.GetOrdinal("구매사판매가격(VAT별도)"))));//구매사판매가격(VAT별도)
                    insertcommand.Parameters.Add(new OracleParameter("GOODSSALEPRICEVAT", reader.GetValue(reader.GetOrdinal("구매사판매가격(VAT포함)"))));//구매사판매가격(VAT포함)
                    insertcommand.Parameters.Add(new OracleParameter("GOODSCUSTPRICE", reader.GetValue(reader.GetOrdinal("판매사가격(VAT별도)"))));//판매사가격(VAT별도)
                    insertcommand.Parameters.Add(new OracleParameter("GOODSCUSTPRICEVAT", reader.GetValue(reader.GetOrdinal("판매사가격(VAT포함)"))));//판매사가격(VAT포함)
                    insertcommand.Parameters.Add(new OracleParameter("GOODSMSALEPRICE", reader.GetValue(reader.GetOrdinal("민간구매사판매가격(VAT별도)"))));//민간구매사판매가격(VAT별도)
                    insertcommand.Parameters.Add(new OracleParameter("GOODSMSALEPRICEVAT", reader.GetValue(reader.GetOrdinal("민간구매사판매가격(VAT포함)"))));//민간구매사판매가격(VAT포함)
                    insertcommand.Parameters.Add(new OracleParameter("SUPPLYCOMPANYCODE1", reader.GetValue(reader.GetOrdinal("공급사코드1"))));//공급사코드1
                    insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSCODE1", reader.GetValue(reader.GetOrdinal("공급사상품코드1"))));//공급사상품코드1
                    insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSUNITMOQ", reader.GetValue(reader.GetOrdinal("매입MOQ1"))));//매입MOQ1
                    insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSENTERDUE", reader.GetValue(reader.GetOrdinal("입고LEADTIME1"))));//입고LEADTIME1
                    insertcommand.Parameters.Add(new OracleParameter("SUPPLYBUYCALC", reader.GetValue(reader.GetOrdinal("매입정산구분1"))));//매입정산구분1
                    insertcommand.Parameters.Add(new OracleParameter("SUPPLYORDERFORM", reader.GetValue(reader.GetOrdinal("발주형태1"))));//발주형태1
                    insertcommand.Parameters.Add(new OracleParameter("SUPPLYCOMPANYCODE2", reader.GetValue(reader.GetOrdinal("공급사코드2"))));//공급사코드2
                    insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSCODE2", reader.GetValue(reader.GetOrdinal("공급사상품코드2"))));//공급사상품코드2
                    insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSUNITMOQ2", reader.GetValue(reader.GetOrdinal("매입MOQ2"))));//매입MOQ2
                    insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSENTERDUE2", reader.GetValue(reader.GetOrdinal("입고LEADTIME2"))));//입고LEADTIME2
                    insertcommand.Parameters.Add(new OracleParameter("SUPPLYBUYCALC2", reader.GetValue(reader.GetOrdinal("매입정산구분2"))));//매입정산구분2
                    insertcommand.Parameters.Add(new OracleParameter("SUPPLYORDERFORM2", reader.GetValue(reader.GetOrdinal("발주형태2"))));//발주형태2
                    

                    insertcommand.ExecuteNonQuery();

                    //

                }
                trans.Commit();   //커밋
                logger.Debug("임시테이블 데이터 넣기 끝");

            }
        }

    }


    protected void UpdateMergeGoods(OracleConnection connection)
    {

        OracleCommand command = new OracleCommand("", connection);


        string updateCommand = @"
                                  MERGE INTO SWP_GOODS u
                                  USING TEMP_GOODS tg on(u.GOODSCODE = tg.GOODSCODE)
                                  WHEN MATCHED THEN UPDATE SET 
              u.BRANDCODE =
              CASE
                           WHEN REPLACE(tg.BRANDCODE,' ' ,'') <> '.'
                           THEN tg.BRANDCODE
                           ELSE u.BRANDCODE
              END ,
              u.GOODSGROUPCODE =
              CASE
                           WHEN REPLACE(tg.GOODSGROUPCODE,' ' ,'') <> '.'
                           THEN tg.GOODSGROUPCODE
                           ELSE u.GOODSGROUPCODE
              END ,
              u.GOODSFINALNAME =
              CASE
                           WHEN REPLACE(tg.GOODSFINALNAME,' ' ,'') <> '.'
                           THEN tg.GOODSFINALNAME
                           ELSE u.GOODSFINALNAME
              END ,
              u.GOODSMODEL =
              CASE
                           WHEN REPLACE(tg.GOODSMODEL,' ' ,'') <> '.'
                           THEN tg.GOODSMODEL
                           WHEN tg.GOODSMODEL IS NULL
                           THEN ''
                           ELSE u.GOODSMODEL
              END ,
              u.GOODSREMINDSEARCH =
              CASE 
                  WHEN REPLACE(tg.GOODSREMINDSEARCH,' ' ,'')  =  '.' THEN u.GOODSREMINDSEARCH
                  WHEN tg.GOODSREMINDSEARCH IS NULL THEN NULL
                  WHEN u.GOODSREMINDSEARCH IS NULL THEN tg.GOODSREMINDSEARCH
                  WHEN u.GOODSREMINDSEARCH IS NOT NULL THEN u.GOODSREMINDSEARCH || ',' || tg.GOODSREMINDSEARCH
                  ELSE tg.GOODSREMINDSEARCH
              END ,
              u.GOODSOPTIONSUMMARYCODE =
              CASE
                           WHEN REPLACE(tg.GOODSOPTIONSUMMARYCODE,' ' ,'') <> '.'
                           THEN tg.GOODSOPTIONSUMMARYCODE
                           ELSE u.GOODSOPTIONSUMMARYCODE
              END ,
              u.GOODSDISPLAYFLAG =
              CASE
                           WHEN REPLACE(tg.GOODSDISPLAYFLAG,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.GOODSDISPLAYFLAG)
                           ELSE TO_NUMBER(u.GOODSDISPLAYFLAG)
              END ,
              u.GOODSNODISPLYREASON =
              CASE
                           WHEN REPLACE(tg.GOODSNODISPLYREASON,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.GOODSNODISPLYREASON)
                           ELSE TO_NUMBER(u.GOODSNODISPLYREASON)
              END ,
              u.GOODSNOSALEREASON =
              CASE
                           WHEN REPLACE(tg.GOODSNOSALEREASON,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.GOODSNOSALEREASON)
                           ELSE TO_NUMBER(u.GOODSNOSALEREASON)
              END ,
              u.GOODSBUYPRICE =
              CASE
                           WHEN REPLACE(tg.GOODSBUYPRICE,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.GOODSBUYPRICE)
                           ELSE TO_NUMBER(u.GOODSBUYPRICE)
              END ,
              u.GOODSBUYPRICEVAT =
              CASE
                           WHEN REPLACE(tg.GOODSBUYPRICEVAT,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.GOODSBUYPRICEVAT)
                           ELSE TO_NUMBER(u.GOODSBUYPRICEVAT)
              END ,
              u.GOODSSALEPRICE =
              CASE
                           WHEN REPLACE(tg.GOODSSALEPRICE,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.GOODSSALEPRICE)
                           ELSE TO_NUMBER(u.GOODSSALEPRICE)
              END ,
              u.GOODSSALEPRICEVAT =
              CASE
                           WHEN REPLACE(tg.GOODSSALEPRICEVAT,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.GOODSSALEPRICEVAT)
                           ELSE TO_NUMBER(u.GOODSSALEPRICEVAT)
              END ,
              u.GOODSCUSTPRICE =
              CASE
                           WHEN REPLACE(tg.GOODSCUSTPRICE,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.GOODSCUSTPRICE)
                           ELSE TO_NUMBER(u.GOODSCUSTPRICE)
              END ,
              u.GOODSCUSTPRICEVAT =
              CASE
                           WHEN REPLACE(tg.GOODSCUSTPRICEVAT,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.GOODSCUSTPRICEVAT)
                           ELSE TO_NUMBER(u.GOODSCUSTPRICEVAT)
              END ,

             u.GOODSMSALEPRICE =
              CASE
                           WHEN REPLACE(tg.GOODSMSALEPRICE,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.GOODSMSALEPRICE)
                           WHEN tg.GOODSMSALEPRICE IS NULL
                           THEN NULL
                           ELSE TO_NUMBER(u.GOODSMSALEPRICE)
              END ,
              u.GOODSMSALEPRICEVAT =
              CASE
                           WHEN REPLACE(tg.GOODSMSALEPRICEVAT,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.GOODSMSALEPRICEVAT)
                           WHEN tg.GOODSMSALEPRICEVAT IS NULL
                           THEN NULL
                           ELSE TO_NUMBER(u.GOODSMSALEPRICEVAT)
              END ,
              
             u.SUPPLYCOMPANYCODE1 =
              CASE
                           WHEN REPLACE(tg.SUPPLYCOMPANYCODE1,' ' ,'') <> '.'
                           THEN tg.SUPPLYCOMPANYCODE1
                           ELSE u.SUPPLYCOMPANYCODE1
              END ,
              u.SUPPLYGOODSCODE1 =
              CASE
                           WHEN REPLACE(tg.SUPPLYGOODSCODE1,' ' ,'') <> '.'
                           THEN tg.SUPPLYGOODSCODE1
                           WHEN tg.SUPPLYGOODSCODE1 IS NULL
                           THEN ''
                           ELSE u.SUPPLYGOODSCODE1
              END ,
              
              u.SUPPLYGOODSUNITMOQ =
              CASE
                           WHEN REPLACE(tg.SUPPLYGOODSUNITMOQ,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.SUPPLYGOODSUNITMOQ)
                           ELSE TO_NUMBER(u.SUPPLYGOODSUNITMOQ)
              END ,
              u.SUPPLYGOODSENTERDUE =
              CASE
                           WHEN REPLACE(tg.SUPPLYGOODSENTERDUE,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.SUPPLYGOODSENTERDUE)
                           ELSE TO_NUMBER(u.SUPPLYGOODSENTERDUE)
              END ,
              u.SUPPLYBUYCALC =
              CASE
                           WHEN REPLACE(tg.SUPPLYBUYCALC,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.SUPPLYBUYCALC)
                           ELSE TO_NUMBER(u.SUPPLYBUYCALC)
              END ,
              u.SUPPLYORDERFORM =
              CASE
                           WHEN REPLACE(tg.SUPPLYORDERFORM,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.SUPPLYORDERFORM)
                           ELSE TO_NUMBER(u.SUPPLYORDERFORM)
              END ,
              
              u.SUPPLYCOMPANYCODE2 =
              CASE
                           WHEN REPLACE(tg.SUPPLYCOMPANYCODE2,' ' ,'') <> '.'
                           THEN tg.SUPPLYCOMPANYCODE2
                           WHEN tg.SUPPLYCOMPANYCODE2 IS NULL
                           THEN ''
                           ELSE u.SUPPLYCOMPANYCODE2
              END ,
              u.SUPPLYGOODSCODE2 =
              CASE
                           WHEN REPLACE(tg.SUPPLYGOODSCODE2,' ' ,'') <> '.'
                           THEN tg.SUPPLYGOODSCODE2
                           WHEN tg.SUPPLYGOODSCODE2 IS NULL
                           THEN ''
                           ELSE u.SUPPLYGOODSCODE2
              END ,
              
              u.SUPPLYGOODSUNITMOQ2 =
              CASE
                           WHEN REPLACE(tg.SUPPLYGOODSUNITMOQ2,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.SUPPLYGOODSUNITMOQ2)
                           WHEN tg.SUPPLYGOODSUNITMOQ2 IS NULL
                           THEN NULL
                           ELSE TO_NUMBER(u.SUPPLYGOODSUNITMOQ2)
              END ,
              u.SUPPLYGOODSENTERDUE2 =
              CASE
                           WHEN REPLACE(tg.SUPPLYGOODSENTERDUE2,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.SUPPLYGOODSENTERDUE2)
                           WHEN tg.SUPPLYGOODSENTERDUE2 IS NULL
                           THEN NULL
                           ELSE TO_NUMBER(u.SUPPLYGOODSENTERDUE2)
              END ,
              u.SUPPLYBUYCALC2 =
              CASE
                           WHEN REPLACE(tg.SUPPLYBUYCALC2,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.SUPPLYBUYCALC2)
                           WHEN tg.SUPPLYBUYCALC2 IS NULL
                           THEN NULL
                           ELSE TO_NUMBER(u.SUPPLYBUYCALC2)
              END ,
              u.SUPPLYORDERFORM2 =
              CASE
                           WHEN REPLACE(tg.SUPPLYORDERFORM2,' ' ,'') <> '.'
                           THEN TO_NUMBER(tg.SUPPLYORDERFORM2)
                           WHEN tg.SUPPLYORDERFORM2 IS NULL
                           THEN NULL
                           ELSE TO_NUMBER(u.SUPPLYORDERFORM2)
              END ,
              
              u.UPDATEDATE = SYSDATE
            ";
        
        using (OracleTransaction trans = connection.BeginTransaction())
        {
            logger.Debug("임시테이블 에서 실제 테이블 데이터 넣기 시작");
            command.CommandText = updateCommand;
            command.ExecuteNonQuery();
            trans.Commit();   //커밋
            logger.Debug("임시테이블 에서 실제 테이블 데이터 넣기 끝");
        }

    }

    //public void UpdateGoods(OleDbDataReader reader, OleDbConnection conn)
    //{

    //    string createTable = @"CREATE TABLE URIAN.TEMP_GOODS (
    //          GOODSFINALCATEGORYCODE VARCHAR2(30 BYTE)        NULL,
    //          GOODSFINALCATEGORYNAME       VARCHAR2(150 BYTE)          NULL, 
    //          GOODSGROUPCODE VARCHAR2(16 BYTE)        NULL,
    //          GOODSCODE                    VARCHAR2(16 BYTE)        NULL,
    //          GOODSFINALNAME               VARCHAR2(80 BYTE)           NULL, 
    //          GOODSOPTIONSUMMARYCODE VARCHAR2(1000 BYTE)      NULL,
    //          BRANDCODE                    VARCHAR2(30 BYTE)        NULL,
    //          GOODSMODEL                   VARCHAR2(200 BYTE)          NULL, 
    //          GOODSUNITMOQ VARCHAR2(50 BYTE)                NULL, 
    //          GOODSDELIVERYORDERDUE VARCHAR2(30 BYTE)               NULL,
    //          GOODSUNITQTY                 VARCHAR2(30 BYTE)                   NULL, 
    //          GOODSUNIT VARCHAR2(7 BYTE)         NULL,
    //          GOODSUNITSUBQTY              VARCHAR2(30 BYTE)                  NULL, 
    //          GOODSSUBUNIT VARCHAR2(7 BYTE)            NULL, 
    //          GOODSSPECIAL VARCHAR2(4000 BYTE)         NULL, 
    //          GOODSFORMAT VARCHAR2(4000 BYTE)         NULL, 
    //          GOODSCAUSE VARCHAR2(4000 BYTE)         NULL, 
    //          GOODSSUPPLIES VARCHAR2(4000 BYTE)         NULL, 
    //          GOODSBUYPRICE VARCHAR2(30 BYTE)             NULL, 
    //          GOODSBUYPRICEVAT VARCHAR2(30 BYTE)               NULL, 
    //          GOODSSALEPRICE VARCHAR2(30 BYTE)             NULL, 
    //          GOODSSALEPRICEVAT VARCHAR2(30 BYTE)             NULL, 
    //          GOODSMSALEPRICE VARCHAR2(30 BYTE)             NULL, 
    //          GOODSMSALEPRICEVAT VARCHAR2(30 BYTE)             NULL, 
    //          GOODSCUSTPRICE VARCHAR2(30 BYTE)            NULL, 
    //          GOODSCUSTPRICEVAT VARCHAR2(30 BYTE)            NULL, 
    //          GOODSREMINDSEARCH VARCHAR2(4000 BYTE)         NULL, 
    //          GOODSALIKESEARCH VARCHAR2(4000 BYTE)         NULL, 
    //          GOODSMDSEQ VARCHAR2(12 BYTE)         NULL, 
    //          MDTOID VARCHAR2(20 BYTE)           NULL, 
    //          MDMEMO VARCHAR2(4000 BYTE)         NULL, 
    //          GOODSDISPLAYFLAG VARCHAR2(10 BYTE)                   NULL, 
    //          GOODSNODISPLYREASON VARCHAR2(10 BYTE)               NULL, 
    //          GOODSNOSALEREASON VARCHAR2(10 BYTE)                NULL, 
    //          GOODSNOSALEENTERTARGETDUE VARCHAR2(10 BYTE)                        NULL, 
    //          GOODSRETURNCHANGEFLAG VARCHAR2(10 BYTE)              NULL, 
    //          GOODSKEEPYN VARCHAR2(10 BYTE)                NULL, 
    //          GOODSSALETAXYN CHAR(1 BYTE)                NULL, 
    //          GOODSDCYN CHAR(1 BYTE)                NULL, 
    //          GOODSCUSTGUBUN VARCHAR2(10 BYTE)                 NULL, 
    //          GOODSSALECUSTGUBUNCODE VARCHAR2(5 BYTE)            NULL, 
    //          SUPPLYBUYGOODSTYPE VARCHAR2(10 BYTE)                  NULL, 
    //          SUPPLYGOODSUNIT VARCHAR2(7 BYTE)         NULL,
    //          SUPPLYGOODSDISTRADMIN        CHAR(1 BYTE)                NULL, 
    //          GOODSORIGINCODE VARCHAR2(5 BYTE)            NULL, 
    //          GOODSSUPPLYCBARCODE1 VARCHAR2(50 BYTE)            NULL, 
    //          GOODSSUPPLYCBARCODE2 VARCHAR2(50 BYTE)            NULL, 
    //          GOODSSUPPLYCBARCODE3 VARCHAR2(50 BYTE)            NULL, 
    //          GOODSCONFIRMMARK VARCHAR2(8 BYTE)            NULL, 
    //          SUPPLYCOMPANYCODE1 VARCHAR2(6 BYTE)         NULL,
    //          SUPPLYGOODSCODE1             VARCHAR2(20 BYTE)           NULL, 
    //          GOODSSUPPLYBARCODE VARCHAR2(60 BYTE)           NULL, 
    //          SUPPLYGOODSUNITMOQ VARCHAR2(30 BYTE)                  NULL, 
    //          SUPPLYGOODSENTERDUE VARCHAR2(10 BYTE)               NULL, 
    //          SUPPLYBUYCALC VARCHAR2(10 BYTE)                NULL, 
    //          SUPPLYORDERFORM VARCHAR2(10 BYTE)                 NULL, 
    //          SUPPLYTRANSCOSTYN VARCHAR2(3 BYTE)                 NULL, 
    //          SUPPLYTRANSCOSTVAT VARCHAR2(10 BYTE)                 NULL, 
    //          SUPPLYGOODSDISTRDUE VARCHAR2(10 BYTE)                 NULL, 
    //          SUPPLYCOMPANYCODE2 VARCHAR2(6 BYTE)            NULL, 
    //          SUPPLYGOODSCODE2 VARCHAR2(20 BYTE)           NULL, 
    //          GOODSSUPPLYBARCODE2 VARCHAR2(60 BYTE)           NULL, 
    //          SUPPLYGOODSUNITMOQ2 VARCHAR2(30 BYTE)                NULL, 
    //          SUPPLYGOODSENTERDUE2 VARCHAR2(30 BYTE)                NULL, 
    //          SUPPLYBUYCALC2 VARCHAR2(30 BYTE)                 NULL, 
    //          SUPPLYORDERFORM2 VARCHAR2(30 BYTE)                NULL, 
    //          SUPPLYTRANSCOSTYN2 VARCHAR2(3 BYTE)                 NULL, 
    //          SUPPLYTRANSCOSTVAT2 VARCHAR2(10 BYTE)                 NULL, 
    //          SUPPLYGOODSDISTRDUE2 VARCHAR2(30 BYTE)                 NULL, 
    //          SUPPLYCOMPANYCODE3 VARCHAR2(6 BYTE)            NULL, 
    //          SUPPLYGOODSCODE3 VARCHAR2(20 BYTE)           NULL, 
    //          GOODSSUPPLYBARCODE3 VARCHAR2(60 BYTE)           NULL, 
    //          SUPPLYGOODSUNITMOQ3 VARCHAR2(30 BYTE)                 NULL, 
    //          SUPPLYGOODSENTERDUE3 VARCHAR2(30 BYTE)                   NULL, 
    //          SUPPLYBUYCALC3 VARCHAR2(30 BYTE)                   NULL, 
    //          SUPPLYORDERFORM3 VARCHAR2(30 BYTE)                 NULL, 
    //          SUPPLYTRANSCOSTYN3 VARCHAR2(3 BYTE)                 NULL, 
    //          SUPPLYTRANSCOSTVAT3 VARCHAR2(10 BYTE)                 NULL, 
    //          SUPPLYGOODSDISTRDUE3 VARCHAR2(30 BYTE)                   NULL, 
    //          DELIVERYGUBUN VARCHAR2(30 BYTE)                  NULL, 
    //          DELIVERYCOSTGUBUN VARCHAR2(30 BYTE)                  NULL, 
    //          DELIVERYCOST_CODE VARCHAR2(8 BYTE)         NULL
    //        )";

    //    string connectionString = ConfigurationManager.AppSettings["ConnectionString"];

    //    // Connect to the AdventureWorks database.  
    //    using (OracleConnection connection = new OracleConnection(connectionString))
    //    {
    //        connection.Open();
    //        OracleCommand command = new OracleCommand("", connection);



    //        string countQuery = @"SELECT COUNT(*)  FROM dba_tables WHERE owner = 'URIAN' AND table_name = 'TEMP_GOODS'";
    //        command.CommandText = countQuery;
    //        int count = command.ExecuteScalar().AsInt();

    //        if (count == 0)
    //        {
    //            logger.Debug("임시테이블 만들기 시작");
    //            command.CommandText = createTable;
    //            command.ExecuteNonQuery();
    //            logger.Debug("임시테이블 만들기 끝");

    //            try
    //            {
    //                InsertTempGoods(connection, reader);
    //                UpdateMergeGoods(connection);   
    //            }
    //            catch (Exception ex)
    //            {
    //                string err = "\r\n 에러 발생 원인 : " + ex.Source +
    //                 "\r\n 에러 메시지    : " + ex.Message +
    //                 "\r\n Stack Trace    : " + ex.StackTrace.ToString() +
    //                 "\r\n 내부 오류      : " + ex.InnerException;
    //                //lblErrorMsg.Text = err;
    //                logger.Error(ex, "기존상품 업로드 에러 msg");
    //                throw;
    //            }
    //            finally
    //            {

    //                string countQuery2 = @"SELECT COUNT(*)  FROM dba_tables WHERE owner = 'URIAN' AND table_name = 'TEMP_GOODS'";
    //                command.CommandText = countQuery2;
    //                int count2 = command.ExecuteScalar().AsInt();

    //                if (count2 > 0)
    //                {
    //                    string dropCommand = "DROP TABLE URIAN.TEMP_GOODS CASCADE CONSTRAINTS";
    //                    command.CommandText = dropCommand;
    //                    command.ExecuteNonQuery();
    //                }
    //            }
    //        }
    //        else
    //        {
    //            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('임시 테이블이 아직 존재합니다. 나중에 다시 시도해 주세요');</script>");
    //        }

    //    }
    //}


    ////임시테이블 Insert
    //protected void InsertTempGoods(OracleConnection connection, OleDbDataReader reader) {

    //    using (OracleTransaction trans = connection.BeginTransaction())
    //    {
    //        string insertQuery = @"INSERT INTO TEMP_GOODS
    //                               (
    //                                       GOODSFINALCATEGORYCODE,
    //                                      GOODSFINALCATEGORYNAME,
    //                                      MDTOID,
    //                                      MDMEMO,
    //                                      BRANDCODE,
    //                                      GOODSGROUPCODE,
    //                                      GOODSCODE,
    //                                      GOODSFINALNAME,
    //                                      GOODSMODEL,
    //                                      GOODSUNITMOQ,
    //                                      GOODSDELIVERYORDERDUE,
    //                                      GOODSUNITQTY,
    //                                      GOODSUNIT,
    //                                      GOODSUNITSUBQTY,
    //                                      GOODSSUBUNIT,
    //                                      GOODSSPECIAL,
    //                                      GOODSFORMAT,
    //                                      GOODSCAUSE,
    //                                      GOODSSUPPLIES,
    //                                      GOODSOPTIONSUMMARYCODE,
    //                                      GOODSREMINDSEARCH,
    //                                      GOODSALIKESEARCH,
    //                                      GOODSMDSEQ,
    //                                      GOODSDISPLAYFLAG,
    //                                      GOODSNODISPLYREASON,
    //                                      GOODSNOSALEREASON,
    //                                      GOODSNOSALEENTERTARGETDUE,
    //                                      GOODSRETURNCHANGEFLAG,
    //                                      GOODSKEEPYN,
    //                                      GOODSSALETAXYN,
    //                                      GOODSDCYN,
    //                                      GOODSCUSTGUBUN,
    //                                      GOODSSALECUSTGUBUNCODE,
    //                                      GOODSBUYPRICE,
    //                                      GOODSBUYPRICEVAT,
    //                                      GOODSSALEPRICE,
    //                                      GOODSSALEPRICEVAT,
    //                                      GOODSCUSTPRICE,
    //                                      GOODSCUSTPRICEVAT,
    //                                      GOODSMSALEPRICE,
    //                                      GOODSMSALEPRICEVAT,
    //                                      SUPPLYBUYGOODSTYPE,
    //                                      SUPPLYGOODSUNIT,
    //                                      SUPPLYGOODSDISTRADMIN,
    //                                      GOODSORIGINCODE,
    //                                      GOODSSUPPLYCBARCODE1,
    //                                      GOODSSUPPLYCBARCODE2,
    //                                      GOODSSUPPLYCBARCODE3,
    //                                      GOODSCONFIRMMARK,
    //                                      SUPPLYCOMPANYCODE1,
    //                                      SUPPLYGOODSCODE1,
    //                                      GOODSSUPPLYBARCODE,
    //                                      SUPPLYGOODSUNITMOQ,
    //                                      SUPPLYGOODSENTERDUE,
    //                                      SUPPLYBUYCALC,
    //                                      SUPPLYORDERFORM,
    //                                      SUPPLYTRANSCOSTYN,
    //                                      SUPPLYTRANSCOSTVAT,
    //                                      SUPPLYGOODSDISTRDUE,
    //                                      SUPPLYCOMPANYCODE2,
    //                                      SUPPLYGOODSCODE2,
    //                                      GOODSSUPPLYBARCODE2,
    //                                      SUPPLYGOODSUNITMOQ2,
    //                                      SUPPLYGOODSENTERDUE2,
    //                                      SUPPLYBUYCALC2,
    //                                      SUPPLYORDERFORM2,
    //                                      SUPPLYTRANSCOSTYN2,
    //                                      SUPPLYTRANSCOSTVAT2,
    //                                      SUPPLYGOODSDISTRDUE2,
    //                                      SUPPLYCOMPANYCODE3,
    //                                      SUPPLYGOODSCODE3,
    //                                      GOODSSUPPLYBARCODE3,
    //                                      SUPPLYGOODSUNITMOQ3,
    //                                      SUPPLYGOODSENTERDUE3,
    //                                      SUPPLYBUYCALC3,
    //                                      SUPPLYORDERFORM3,
    //                                      SUPPLYTRANSCOSTYN3,
    //                                      SUPPLYTRANSCOSTVAT3,
    //                                      SUPPLYGOODSDISTRDUE3,
    //                                      DELIVERYGUBUN,
    //                                      DELIVERYCOSTGUBUN,
    //                                      DELIVERYCOST_CODE

    //                               )
    //                               VALUES
    //                               (

    //                                       :GOODSFINALCATEGORYCODE,
    //                                      :GOODSFINALCATEGORYNAME,
    //                                      :MDTOID,
    //                                      :MDMEMO,
    //                                      :BRANDCODE,
    //                                      :GOODSGROUPCODE,
    //                                      :GOODSCODE,
    //                                      :GOODSFINALNAME,
    //                                      :GOODSMODEL,
    //                                      :GOODSUNITMOQ,
    //                                      :GOODSDELIVERYORDERDUE,
    //                                      :GOODSUNITQTY,
    //                                      :GOODSUNIT,
    //                                      :GOODSUNITSUBQTY,
    //                                      :GOODSSUBUNIT,
    //                                      :GOODSSPECIAL,
    //                                      :GOODSFORMAT,
    //                                      :GOODSCAUSE,
    //                                      :GOODSSUPPLIES,
    //                                      :GOODSOPTIONSUMMARYCODE,
    //                                      :GOODSREMINDSEARCH,
    //                                      :GOODSALIKESEARCH,
    //                                      :GOODSMDSEQ,
    //                                      :GOODSDISPLAYFLAG,
    //                                      :GOODSNODISPLYREASON,
    //                                      :GOODSNOSALEREASON,
    //                                      :GOODSNOSALEENTERTARGETDUE,
    //                                      :GOODSRETURNCHANGEFLAG,
    //                                      :GOODSKEEPYN,
    //                                      :GOODSSALETAXYN,
    //                                      :GOODSDCYN,
    //                                      :GOODSCUSTGUBUN,
    //                                      :GOODSSALECUSTGUBUNCODE,
    //                                      :GOODSBUYPRICE,
    //                                      :GOODSBUYPRICEVAT,
    //                                      :GOODSSALEPRICE,
    //                                      :GOODSSALEPRICEVAT,
    //                                      :GOODSCUSTPRICE,
    //                                      :GOODSCUSTPRICEVAT,
    //                                      :GOODSMSALEPRICE,
    //                                      :GOODSMSALEPRICEVAT,
    //                                      :SUPPLYBUYGOODSTYPE,
    //                                      :SUPPLYGOODSUNIT,
    //                                      :SUPPLYGOODSDISTRADMIN,
    //                                      :GOODSORIGINCODE,
    //                                      :GOODSSUPPLYCBARCODE1,
    //                                      :GOODSSUPPLYCBARCODE2,
    //                                      :GOODSSUPPLYCBARCODE3,
    //                                      :GOODSCONFIRMMARK,
    //                                      :SUPPLYCOMPANYCODE1,
    //                                      :SUPPLYGOODSCODE1,
    //                                      :GOODSSUPPLYBARCODE,
    //                                      :SUPPLYGOODSUNITMOQ,
    //                                      :SUPPLYGOODSENTERDUE,
    //                                      :SUPPLYBUYCALC,
    //                                      :SUPPLYORDERFORM,
    //                                      :SUPPLYTRANSCOSTYN,
    //                                      :SUPPLYTRANSCOSTVAT,
    //                                      :SUPPLYGOODSDISTRDUE,
    //                                      :SUPPLYCOMPANYCODE2,
    //                                      :SUPPLYGOODSCODE2,
    //                                      :GOODSSUPPLYBARCODE2,
    //                                      :SUPPLYGOODSUNITMOQ2,
    //                                      :SUPPLYGOODSENTERDUE2,
    //                                      :SUPPLYBUYCALC2,
    //                                      :SUPPLYORDERFORM2,
    //                                      :SUPPLYTRANSCOSTYN2,
    //                                      :SUPPLYTRANSCOSTVAT2,
    //                                      :SUPPLYGOODSDISTRDUE2,
    //                                      :SUPPLYCOMPANYCODE3,
    //                                      :SUPPLYGOODSCODE3,
    //                                      :GOODSSUPPLYBARCODE3,
    //                                      :SUPPLYGOODSUNITMOQ3,
    //                                      :SUPPLYGOODSENTERDUE3,
    //                                      :SUPPLYBUYCALC3,
    //                                      :SUPPLYORDERFORM3,
    //                                      :SUPPLYTRANSCOSTYN3,
    //                                      :SUPPLYTRANSCOSTVAT3,
    //                                      :SUPPLYGOODSDISTRDUE3,
    //                                      :DELIVERYGUBUN,
    //                                      :DELIVERYCOSTGUBUN,
    //                                      :DELIVERYCOST_CODE

    //                               )";

    //        if (reader.HasRows)
    //        {
    //            logger.Debug("임시테이블 데이터 넣기 시작");
    //            while (reader.Read())
    //            {


    //                OracleCommand insertcommand = new OracleCommand(insertQuery, connection);
    //                //insertcommand.Transaction = transaction;
    //                insertcommand.CommandType = CommandType.Text;

    //                insertcommand.Parameters.Add(new OracleParameter("GOODSFINALCATEGORYCODE", reader.GetValue(reader.GetOrdinal("최종카테고리")))); //최종카테고리
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSFINALCATEGORYNAME", reader.GetValue(reader.GetOrdinal("최종카테고리명")))); //최종카테고리명
    //                insertcommand.Parameters.Add(new OracleParameter("MDTOID", reader.GetValue(reader.GetOrdinal("담당MD아이디"))));//담당MD아이디
    //                insertcommand.Parameters.Add(new OracleParameter("MDMEMO", reader.GetValue(reader.GetOrdinal("MD메모"))));//MD메모
    //                insertcommand.Parameters.Add(new OracleParameter("BRANDCODE", reader.GetValue(reader.GetOrdinal("브랜드코드"))));//브랜드코드
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSGROUPCODE", reader.GetValue(reader.GetOrdinal("그룹코드"))));//그룹코드
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSCODE", reader.GetValue(reader.GetOrdinal("상품코드"))));//상품코드
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSFINALNAME", reader.GetValue(reader.GetOrdinal("상품명"))));//상품명
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSMODEL", reader.GetValue(reader.GetOrdinal("모델명"))));//모델명
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSUNITMOQ", reader.GetValue(reader.GetOrdinal("MOQ(최소판매수량)"))));//MOQ(최소판매수량)
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSDELIVERYORDERDUE", reader.GetValue(reader.GetOrdinal("출고예정일"))));//출고예정일
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSUNITQTY", reader.GetValue(reader.GetOrdinal("내용량"))));//내용량
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSUNIT", reader.GetValue(reader.GetOrdinal("단위코드"))));//단위코드
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSUNITSUBQTY", reader.GetValue(reader.GetOrdinal("서브내용량"))));//서브내용량
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSSUBUNIT", reader.GetValue(reader.GetOrdinal("서브단위코드"))));//서브단위코드
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSSPECIAL", reader.GetValue(reader.GetOrdinal("특징"))));//특징
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSFORMAT", reader.GetValue(reader.GetOrdinal("형식"))));//형식
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSCAUSE", reader.GetValue(reader.GetOrdinal("주의사항"))));//주의사항
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSSUPPLIES", reader.GetValue(reader.GetOrdinal("용도"))));//용도
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSOPTIONSUMMARYCODE", reader.GetValue(reader.GetOrdinal("옵션코드"))));//옵션코드
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSREMINDSEARCH", reader.GetValue(reader.GetOrdinal("연관검색어"))));//연관검색어
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSALIKESEARCH", reader.GetValue(reader.GetOrdinal("관련상품설정"))));//관련상품설정
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSMDSEQ", reader.GetValue(reader.GetOrdinal("상품전시우선순위"))));//상품전시우선순위
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSDISPLAYFLAG", reader.GetValue(reader.GetOrdinal("상품노출여부"))));//상품노출여부
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSNODISPLYREASON", reader.GetValue(reader.GetOrdinal("비노출사유"))));//비노출사유
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSNOSALEREASON", reader.GetValue(reader.GetOrdinal("판매중단사유"))));//판매중단사유
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSNOSALEENTERTARGETDUE", reader.GetValue(reader.GetOrdinal("품절품목입고예정일"))));//품절품목입고예정일
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSRETURNCHANGEFLAG", reader.GetValue(reader.GetOrdinal("반품(교환)불가여부"))));//반품(교환)불가여부
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSKEEPYN", reader.GetValue(reader.GetOrdinal("재고관리여부"))));//재고관리여부
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSSALETAXYN", reader.GetValue(reader.GetOrdinal("판매과세여부"))));//판매과세여부
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSDCYN", reader.GetValue(reader.GetOrdinal("추가DC적용여부"))));//추가DC적용여부
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSCUSTGUBUN", reader.GetValue(reader.GetOrdinal("고객사상품구분"))));//고객사상품구분
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSSALECUSTGUBUNCODE", reader.GetValue(reader.GetOrdinal("특정판매고객사코드"))));//특정판매고객사코드
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSBUYPRICE", reader.GetValue(reader.GetOrdinal("매입가격(VAT별도)"))));//매입가격(VAT별도)
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSBUYPRICEVAT", reader.GetValue(reader.GetOrdinal("매입가격(VAT포함)"))));//매입가격(VAT포함)
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSSALEPRICE", reader.GetValue(reader.GetOrdinal("구매사판매가격(VAT별도)"))));//구매사판매가격(VAT별도)
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSSALEPRICEVAT", reader.GetValue(reader.GetOrdinal("구매사판매가격(VAT포함)"))));//구매사판매가격(VAT포함)
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSCUSTPRICE", reader.GetValue(reader.GetOrdinal("판매사가격(VAT별도)"))));//판매사가격(VAT별도)
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSCUSTPRICEVAT", reader.GetValue(reader.GetOrdinal("판매사가격(VAT포함)"))));//판매사가격(VAT포함)
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSMSALEPRICE", reader.GetValue(reader.GetOrdinal("민간구매사판매가격(VAT별도)"))));//민간구매사판매가격(VAT별도)
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSMSALEPRICEVAT", reader.GetValue(reader.GetOrdinal("민간구매사판매가격(VAT포함)"))));//민간구매사판매가격(VAT포함)
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYBUYGOODSTYPE", reader.GetValue(reader.GetOrdinal("매입상품유형"))));//매입상품유형
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSUNIT", reader.GetValue(reader.GetOrdinal("공급사단위코드"))));//공급사단위코드
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSDISTRADMIN", reader.GetValue(reader.GetOrdinal("상품유통기간관리여부"))));//상품유통기간관리여부
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSORIGINCODE", reader.GetValue(reader.GetOrdinal("원산지코드"))));//원산지코드
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSSUPPLYCBARCODE1", reader.GetValue(reader.GetOrdinal("상품바코드(낱개)"))));//상품바코드(낱개)
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSSUPPLYCBARCODE2", reader.GetValue(reader.GetOrdinal("상품바코드(inbox)"))));//상품바코드(inbox)
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSSUPPLYCBARCODE3", reader.GetValue(reader.GetOrdinal("상품바코드(outbox)"))));//상품바코드(outbox)
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSCONFIRMMARK", reader.GetValue(reader.GetOrdinal("상품인증구분"))));//상품인증구분
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYCOMPANYCODE1", reader.GetValue(reader.GetOrdinal("공급사코드1"))));//공급사코드1
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSCODE1", reader.GetValue(reader.GetOrdinal("공급사상품코드1"))));//공급사상품코드1
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSSUPPLYBARCODE", reader.GetValue(reader.GetOrdinal("상품바코드1"))));//상품바코드1
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSUNITMOQ", reader.GetValue(reader.GetOrdinal("매입MOQ1"))));//매입MOQ1
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSENTERDUE", reader.GetValue(reader.GetOrdinal("입고LEADTIME1"))));//입고LEADTIME1
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYBUYCALC", reader.GetValue(reader.GetOrdinal("매입정산구분1"))));//매입정산구분1
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYORDERFORM", reader.GetValue(reader.GetOrdinal("발주형태1"))));//발주형태1
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYTRANSCOSTYN", reader.GetValue(reader.GetOrdinal("매입운송비유무1"))));//매입운송비유무1
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYTRANSCOSTVAT", reader.GetValue(reader.GetOrdinal("매입운송비용1"))));//매입운송비용1
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSDISTRDUE1", reader.GetValue(reader.GetOrdinal("상품제조유통기간1"))));//상품제조유통기간1
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYCOMPANYCODE2", reader.GetValue(reader.GetOrdinal("공급사코드2"))));//공급사코드2
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSCODE2", reader.GetValue(reader.GetOrdinal("공급사상품코드2"))));//공급사상품코드2
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSSUPPLYBARCODE2", reader.GetValue(reader.GetOrdinal("상품바코드2"))));//상품바코드2
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSUNITMOQ2", reader.GetValue(reader.GetOrdinal("매입MOQ2"))));//매입MOQ2
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSENTERDUE2", reader.GetValue(reader.GetOrdinal("입고LEADTIME2"))));//입고LEADTIME2
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYBUYCALC2", reader.GetValue(reader.GetOrdinal("매입정산구분2"))));//매입정산구분2
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYORDERFORM2", reader.GetValue(reader.GetOrdinal("발주형태2"))));//발주형태2
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYTRANSCOSTYN2", reader.GetValue(reader.GetOrdinal("매입운송비유무2"))));//매입운송비유무2
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYTRANSCOSTVAT2", reader.GetValue(reader.GetOrdinal("매입운송비용2"))));//매입운송비용2
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSDISTRDUE2", reader.GetValue(reader.GetOrdinal("상품제조유통기간2"))));//상품제조유통기간2
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYCOMPANYCODE3", reader.GetValue(reader.GetOrdinal("공급사코드3"))));//공급사코드3
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSCODE3", reader.GetValue(reader.GetOrdinal("공급사상품코드3"))));//공급사상품코드3
    //                insertcommand.Parameters.Add(new OracleParameter("GOODSSUPPLYBARCODE3", reader.GetValue(reader.GetOrdinal("상품바코드3"))));//상품바코드3
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSUNITMOQ3", reader.GetValue(reader.GetOrdinal("매입MOQ3"))));//매입MOQ3
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSENTERDUE3", reader.GetValue(reader.GetOrdinal("입고LEADTIME3"))));//입고LEADTIME3
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYBUYCALC3", reader.GetValue(reader.GetOrdinal("매입정산구분3"))));//매입정산구분3
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYORDERFORM3", reader.GetValue(reader.GetOrdinal("발주형태3"))));//발주형태3
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYTRANSCOSTYN3", reader.GetValue(reader.GetOrdinal("매입운송비유무3"))));//매입운송비유무3
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYTRANSCOSTVAT3", reader.GetValue(reader.GetOrdinal("매입운송비용3"))));//매입운송비용3
    //                insertcommand.Parameters.Add(new OracleParameter("SUPPLYGOODSDISTRDUE3", reader.GetValue(reader.GetOrdinal("상품제조유통기간3"))));//상품제조유통기간3
    //                insertcommand.Parameters.Add(new OracleParameter("DELIVERYGUBUN", reader.GetValue(reader.GetOrdinal("배송구분"))));//배송구분
    //                insertcommand.Parameters.Add(new OracleParameter("DELIVERYCOSTGUBUN", reader.GetValue(reader.GetOrdinal("배송비구분"))));//배송비구분
    //                insertcommand.Parameters.Add(new OracleParameter("DELIVERYCOST_CODE", reader.GetValue(reader.GetOrdinal("배송비 비용코드"))));//배송비 비용코드

    //                insertcommand.ExecuteNonQuery();

    //                //

    //            }
    //            trans.Commit();   //커밋
    //            logger.Debug("임시테이블 데이터 넣기 끝");

    //        }
    //    }

    //}


    //protected void UpdateMergeGoods(OracleConnection connection) {

    //    OracleCommand command = new OracleCommand("", connection);


    //        string updateCommand = @"
    //                              MERGE INTO U_GOODS u
    //                              USING TEMP_GOODS tg on(u.GOODSCODE = tg.GOODSCODE)
    //                              WHEN MATCHED THEN UPDATE SET u.GOODSFINALCATEGORYCODE =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSFINALCATEGORYCODE,' ' ,'') <> '.'
    //                       THEN tg.GOODSFINALCATEGORYCODE
    //                       ELSE u.GOODSFINALCATEGORYCODE
    //          END,
    //          u.GOODSFINALCATEGORYNAME =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSFINALCATEGORYNAME,' ' ,'') <> '.'
    //                       THEN tg.GOODSFINALCATEGORYNAME
    //                       ELSE u.GOODSFINALCATEGORYNAME
    //          END ,
    //          u.GOODSGROUPCODE =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSGROUPCODE,' ' ,'') <> '.'
    //                       THEN tg.GOODSGROUPCODE
    //                       ELSE u.GOODSGROUPCODE
    //          END ,
    //          u.GOODSFINALNAME =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSFINALNAME,' ' ,'') <> '.'
    //                       THEN tg.GOODSFINALNAME
    //                       ELSE u.GOODSFINALNAME
    //          END ,
    //          u.GOODSOPTIONSUMMARYCODE =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSOPTIONSUMMARYCODE,' ' ,'') <> '.'
    //                       THEN tg.GOODSOPTIONSUMMARYCODE
    //                       ELSE u.GOODSOPTIONSUMMARYCODE
    //          END ,
    //          u.BRANDCODE =
    //          CASE
    //                       WHEN REPLACE(tg.BRANDCODE,' ' ,'') <> '.'
    //                       THEN tg.BRANDCODE
    //                       ELSE u.BRANDCODE
    //          END ,
    //          u.GOODSMODEL =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSMODEL,' ' ,'') <> '.'
    //                       THEN tg.GOODSMODEL
    //                       ELSE u.GOODSMODEL
    //          END ,
    //          u.GOODSUNITMOQ =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSUNITMOQ,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSUNITMOQ)
    //                       ELSE TO_NUMBER(u.GOODSUNITMOQ)
    //          END ,
    //          u.GOODSDELIVERYORDERDUE =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSDELIVERYORDERDUE,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSDELIVERYORDERDUE)
    //                       ELSE TO_NUMBER(u.GOODSDELIVERYORDERDUE)
    //          END ,
    //          u.GOODSUNITQTY =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSUNITQTY,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSUNITQTY)
    //                       ELSE TO_NUMBER(u.GOODSUNITQTY)
    //          END ,
    //          u.GOODSUNIT =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSUNIT,' ' ,'') <> '.'
    //                       THEN tg.GOODSUNIT
    //                       ELSE u.GOODSUNIT
    //          END ,
    //          u.GOODSUNITSUBQTY =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSUNITSUBQTY,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSUNITSUBQTY)
    //                       ELSE TO_NUMBER(u.GOODSUNITSUBQTY)
    //          END ,
    //          u.GOODSSUBUNIT =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSSUBUNIT,' ' ,'') <> '.'
    //                       THEN tg.GOODSSUBUNIT
    //                       ELSE u.GOODSSUBUNIT
    //          END ,
    //          u.GOODSSPECIAL =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSSPECIAL,' ' ,'') <> '.'
    //                       THEN tg.GOODSSPECIAL
    //                       ELSE u.GOODSSPECIAL
    //          END ,
    //          u.GOODSFORMAT =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSFORMAT,' ' ,'') <> '.'
    //                       THEN tg.GOODSFORMAT
    //                       ELSE u.GOODSFORMAT
    //          END ,
    //          u.GOODSCAUSE =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSCAUSE,' ' ,'') <> '.'
    //                       THEN tg.GOODSCAUSE
    //                       ELSE u.GOODSCAUSE
    //          END ,
    //          u.GOODSSUPPLIES =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSSUPPLIES,' ' ,'') <> '.'
    //                       THEN tg.GOODSSUPPLIES
    //                       ELSE u.GOODSSUPPLIES
    //          END ,
    //          u.GOODSBUYPRICE =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSBUYPRICE,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSBUYPRICE)
    //                       ELSE TO_NUMBER(u.GOODSBUYPRICE)
    //          END ,
    //          u.GOODSBUYPRICEVAT =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSBUYPRICEVAT,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSBUYPRICEVAT)
    //                       ELSE TO_NUMBER(u.GOODSBUYPRICEVAT)
    //          END ,
    //          u.GOODSSALEPRICE =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSSALEPRICE,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSSALEPRICE)
    //                       ELSE TO_NUMBER(u.GOODSSALEPRICE)
    //          END ,
    //          u.GOODSSALEPRICEVAT =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSSALEPRICEVAT,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSSALEPRICEVAT)
    //                       ELSE TO_NUMBER(u.GOODSSALEPRICEVAT)
    //          END ,
    //          u.GOODSCUSTPRICE =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSCUSTPRICE,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSCUSTPRICE)
    //                       ELSE TO_NUMBER(u.GOODSCUSTPRICE)
    //          END ,
    //          u.GOODSCUSTPRICEVAT =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSCUSTPRICEVAT,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSCUSTPRICEVAT)
    //                       ELSE TO_NUMBER(u.GOODSCUSTPRICEVAT)
    //          END ,

    //         u.GOODSMSALEPRICE =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSMSALEPRICE,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSMSALEPRICE)
    //                       WHEN tg.GOODSMSALEPRICE IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.GOODSMSALEPRICE)
    //          END ,
    //          u.GOODSMSALEPRICEVAT =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSMSALEPRICEVAT,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSMSALEPRICEVAT)
    //                       WHEN tg.GOODSMSALEPRICEVAT IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.GOODSMSALEPRICEVAT)
    //          END ,
    //          u.GOODSREMINDSEARCH =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSREMINDSEARCH,' ' ,'') <> '.'
    //                       THEN tg.GOODSREMINDSEARCH
    //                       WHEN tg.GOODSREMINDSEARCH IS NULL
    //                       THEN NULL
    //                       ELSE u.GOODSREMINDSEARCH
    //          END ,
    //          u.GOODSALIKESEARCH =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSALIKESEARCH,' ' ,'') <> '.'
    //                       THEN tg.GOODSALIKESEARCH
    //                       WHEN tg.GOODSALIKESEARCH IS NULL
    //                       THEN NULL
    //                       ELSE u.GOODSALIKESEARCH
    //          END ,
    //          u.GOODSMDSEQ =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSMDSEQ,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSMDSEQ)
    //                       WHEN tg.GOODSMDSEQ IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.GOODSMDSEQ)
    //          END ,
    //          u.MDTOID =
    //          CASE
    //                       WHEN REPLACE(tg.MDTOID,' ' ,'') <> '.'
    //                       THEN tg.MDTOID
    //                       ELSE u.MDTOID
    //          END ,
    //          u.MDMEMO =
    //          CASE
    //                       WHEN REPLACE(tg.MDMEMO,' ' ,'') <> '.'
    //                       THEN tg.MDMEMO
    //                       WHEN tg.MDMEMO IS NULL
    //                       THEN NULL
    //                       ELSE u.MDMEMO
    //          END ,
    //          u.GOODSDISPLAYFLAG =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSDISPLAYFLAG,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSDISPLAYFLAG)
    //                       ELSE TO_NUMBER(u.GOODSDISPLAYFLAG)
    //          END ,
    //          u.GOODSNODISPLYREASON =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSNODISPLYREASON,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSNODISPLYREASON)
    //                       ELSE TO_NUMBER(u.GOODSNODISPLYREASON)
    //          END ,
    //          u.GOODSNOSALEREASON =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSNOSALEREASON,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSNOSALEREASON)
    //                       ELSE TO_NUMBER(u.GOODSNOSALEREASON)
    //          END ,
    //          u.GOODSNOSALEENTERTARGETDUE =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSNOSALEENTERTARGETDUE,' ' ,'') <> '.'
    //                       THEN TO_DATE(tg.GOODSNOSALEENTERTARGETDUE,'YYYY-MM-DD')
    //                       ELSE TO_DATE(u.GOODSNOSALEENTERTARGETDUE,'YYYY-MM-DD')
    //          END ,
    //          u.GOODSRETURNCHANGEFLAG =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSRETURNCHANGEFLAG,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSRETURNCHANGEFLAG)
    //                       ELSE TO_NUMBER(u.GOODSRETURNCHANGEFLAG)
    //          END ,
    //          u.GOODSKEEPYN =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSKEEPYN,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSKEEPYN)
    //                       ELSE TO_NUMBER(u.GOODSKEEPYN)
    //          END ,
    //          u.GOODSSALETAXYN =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSSALETAXYN,' ' ,'') <> '.'
    //                       THEN tg.GOODSSALETAXYN
    //                       ELSE u.GOODSSALETAXYN
    //          END ,
    //          u.GOODSDCYN =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSDCYN,' ' ,'') <> '.'
    //                       THEN tg.GOODSDCYN
    //                       ELSE u.GOODSDCYN
    //          END ,
    //          u.GOODSCUSTGUBUN =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSCUSTGUBUN,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.GOODSCUSTGUBUN)
    //                       ELSE TO_NUMBER(u.GOODSCUSTGUBUN)
    //          END ,
    //          u.GOODSSALECUSTGUBUNCODE =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSSALECUSTGUBUNCODE,' ' ,'') <> '.'
    //                       THEN tg.GOODSSALECUSTGUBUNCODE
    //                       ELSE u.GOODSSALECUSTGUBUNCODE
    //          END ,
    //          u.SUPPLYBUYGOODSTYPE =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYBUYGOODSTYPE,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYBUYGOODSTYPE)
    //                       ELSE TO_NUMBER(u.SUPPLYBUYGOODSTYPE)
    //          END ,
    //          u.SUPPLYGOODSUNIT =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYGOODSUNIT,' ' ,'') <> '.'
    //                       THEN tg.SUPPLYGOODSUNIT
    //                       ELSE u.SUPPLYGOODSUNIT
    //          END ,
    //          u.SUPPLYGOODSDISTRADMIN =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYGOODSDISTRADMIN,' ' ,'') <> '.'
    //                       THEN tg.SUPPLYGOODSDISTRADMIN
    //                       ELSE u.SUPPLYGOODSDISTRADMIN
    //          END ,
    //          u.GOODSORIGINCODE =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSORIGINCODE,' ' ,'') <> '.'
    //                       THEN tg.GOODSORIGINCODE
    //                       ELSE u.GOODSORIGINCODE
    //          END ,
    //        u.GOODSSUPPLYCBARCODE1 =
    //                        CASE
    //                                    WHEN REPLACE(tg.GOODSSUPPLYCBARCODE1,' ' ,'') <> '.'
    //                                    THEN tg.GOODSSUPPLYCBARCODE1
    //                                    WHEN tg.GOODSSUPPLYCBARCODE1 IS NULL
    //                                    THEN ''
    //                                    ELSE u.GOODSSUPPLYCBARCODE1
    //                        END ,
    //        u.GOODSSUPPLYCBARCODE2 =
    //                        CASE
    //                                    WHEN REPLACE(tg.GOODSSUPPLYCBARCODE2,' ' ,'') <> '.'
    //                                    THEN tg.GOODSSUPPLYCBARCODE2
    //                                    WHEN tg.GOODSSUPPLYCBARCODE2 IS NULL
    //                                    THEN ''
    //                                    ELSE u.GOODSSUPPLYCBARCODE2
    //                        END ,
    //        u.GOODSSUPPLYCBARCODE3 =
    //                        CASE
    //                                    WHEN REPLACE(tg.GOODSSUPPLYCBARCODE3,' ' ,'') <> '.'
    //                                    THEN tg.GOODSSUPPLYCBARCODE3
    //                                    WHEN tg.GOODSSUPPLYCBARCODE3 IS NULL
    //                                    THEN ''
    //                                    ELSE u.GOODSSUPPLYCBARCODE3
    //                        END ,
    //        u.GOODSCONFIRMMARK =
    //                        CASE
    //                                    WHEN REPLACE(tg.GOODSCONFIRMMARK,' ' ,'') <> '.'
    //                                    THEN tg.GOODSCONFIRMMARK
    //                                    WHEN tg.GOODSCONFIRMMARK IS NULL
    //                                    THEN ''
    //                                    ELSE u.GOODSCONFIRMMARK
    //                        END ,
    //         u.SUPPLYCOMPANYCODE1 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYCOMPANYCODE1,' ' ,'') <> '.'
    //                       THEN tg.SUPPLYCOMPANYCODE1
    //                       ELSE u.SUPPLYCOMPANYCODE1
    //          END ,
    //          u.SUPPLYGOODSCODE1 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYGOODSCODE1,' ' ,'') <> '.'
    //                       THEN tg.SUPPLYGOODSCODE1
    //                       WHEN tg.SUPPLYGOODSCODE1 IS NULL
    //                       THEN ''
    //                       ELSE u.SUPPLYGOODSCODE1
    //          END ,
    //          u.GOODSSUPPLYBARCODE =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSSUPPLYBARCODE,' ' ,'') <> '.'
    //                       THEN tg.GOODSSUPPLYBARCODE
    //                       ELSE u.GOODSSUPPLYBARCODE
    //          END ,
    //          u.SUPPLYGOODSUNITMOQ =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYGOODSUNITMOQ,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYGOODSUNITMOQ)
    //                       ELSE TO_NUMBER(u.SUPPLYGOODSUNITMOQ)
    //          END ,
    //          u.SUPPLYGOODSENTERDUE =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYGOODSENTERDUE,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYGOODSENTERDUE)
    //                       ELSE TO_NUMBER(u.SUPPLYGOODSENTERDUE)
    //          END ,
    //          u.SUPPLYBUYCALC =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYBUYCALC,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYBUYCALC)
    //                       ELSE TO_NUMBER(u.SUPPLYBUYCALC)
    //          END ,
    //          u.SUPPLYORDERFORM =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYORDERFORM,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYORDERFORM)
    //                       ELSE TO_NUMBER(u.SUPPLYORDERFORM)
    //          END ,
    //          u.SUPPLYTRANSCOSTYN =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYTRANSCOSTYN,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYTRANSCOSTYN)
    //                       WHEN tg.SUPPLYTRANSCOSTYN IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.SUPPLYTRANSCOSTYN)
    //          END ,
    //          u.SUPPLYTRANSCOSTVAT =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYTRANSCOSTVAT,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYTRANSCOSTVAT)
    //                       WHEN tg.SUPPLYTRANSCOSTVAT IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.SUPPLYTRANSCOSTVAT)
    //          END ,
    //          u.SUPPLYGOODSDISTRDUE =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYGOODSDISTRDUE,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYGOODSDISTRDUE)
    //                       ELSE TO_NUMBER(u.SUPPLYGOODSDISTRDUE)
    //          END ,
    //          u.SUPPLYCOMPANYCODE2 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYCOMPANYCODE2,' ' ,'') <> '.'
    //                       THEN tg.SUPPLYCOMPANYCODE2
    //                       WHEN tg.SUPPLYCOMPANYCODE2 IS NULL
    //                       THEN ''
    //                       ELSE u.SUPPLYCOMPANYCODE2
    //          END ,
    //          u.SUPPLYGOODSCODE2 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYGOODSCODE2,' ' ,'') <> '.'
    //                       THEN tg.SUPPLYGOODSCODE2
    //                       WHEN tg.SUPPLYGOODSCODE2 IS NULL
    //                       THEN ''
    //                       ELSE u.SUPPLYGOODSCODE2
    //          END ,
    //          u.GOODSSUPPLYBARCODE2 =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSSUPPLYBARCODE2,' ' ,'') <> '.'
    //                       THEN tg.GOODSSUPPLYBARCODE2
    //                       WHEN tg.GOODSSUPPLYBARCODE2 IS NULL
    //                       THEN ''
    //                       ELSE u.GOODSSUPPLYBARCODE2
    //          END ,
    //          u.SUPPLYGOODSUNITMOQ2 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYGOODSUNITMOQ2,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYGOODSUNITMOQ2)
    //                       WHEN tg.SUPPLYGOODSUNITMOQ2 IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.SUPPLYGOODSUNITMOQ2)
    //          END ,
    //          u.SUPPLYGOODSENTERDUE2 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYGOODSENTERDUE2,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYGOODSENTERDUE2)
    //                       WHEN tg.SUPPLYGOODSENTERDUE2 IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.SUPPLYGOODSENTERDUE2)
    //          END ,
    //          u.SUPPLYBUYCALC2 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYBUYCALC2,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYBUYCALC2)
    //                       WHEN tg.SUPPLYBUYCALC2 IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.SUPPLYBUYCALC2)
    //          END ,
    //          u.SUPPLYORDERFORM2 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYORDERFORM2,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYORDERFORM2)
    //                       WHEN tg.SUPPLYORDERFORM2 IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.SUPPLYORDERFORM2)
    //          END ,
    //          u.SUPPLYTRANSCOSTYN2 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYTRANSCOSTYN2,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYTRANSCOSTYN2)
    //                       WHEN tg.SUPPLYTRANSCOSTYN2 IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.SUPPLYTRANSCOSTYN2)
    //          END ,
    //          u.SUPPLYTRANSCOSTVAT2 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYTRANSCOSTVAT2,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYTRANSCOSTVAT2)
    //                       WHEN tg.SUPPLYTRANSCOSTVAT2 IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.SUPPLYTRANSCOSTVAT2)
    //          END ,
    //          u.SUPPLYGOODSDISTRDUE2 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYGOODSDISTRDUE2,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYGOODSDISTRDUE2)
    //                       WHEN tg.SUPPLYGOODSDISTRDUE2 IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.SUPPLYGOODSDISTRDUE2)
    //          END ,
    //          u.SUPPLYCOMPANYCODE3 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYCOMPANYCODE3,' ' ,'') <> '.'
    //                       THEN tg.SUPPLYCOMPANYCODE3
    //                       WHEN tg.SUPPLYCOMPANYCODE3 IS NULL
    //                       THEN ''
    //                       ELSE u.SUPPLYCOMPANYCODE3
    //          END ,
    //          u.SUPPLYGOODSCODE3 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYGOODSCODE3,' ' ,'') <> '.'
    //                       THEN tg.SUPPLYGOODSCODE3
    //                       WHEN tg.SUPPLYGOODSCODE3 IS NULL
    //                       THEN ''
    //                       ELSE u.SUPPLYGOODSCODE3
    //          END ,
    //          u.GOODSSUPPLYBARCODE3 =
    //          CASE
    //                       WHEN REPLACE(tg.GOODSSUPPLYBARCODE3,' ' ,'') <> '.'
    //                       THEN tg.GOODSSUPPLYBARCODE3
    //                       WHEN tg.GOODSSUPPLYBARCODE3 IS NULL
    //                       THEN ''
    //                       ELSE u.GOODSSUPPLYBARCODE3
    //          END ,
    //          u.SUPPLYGOODSUNITMOQ3 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYGOODSUNITMOQ3,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYGOODSUNITMOQ3)
    //                       WHEN tg.SUPPLYGOODSUNITMOQ3 IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.SUPPLYGOODSUNITMOQ3)
    //          END ,
    //          u.SUPPLYGOODSENTERDUE3 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYGOODSENTERDUE3,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYGOODSENTERDUE3)
    //                       WHEN tg.SUPPLYGOODSENTERDUE3 IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.SUPPLYGOODSENTERDUE3)
    //          END ,
    //          u.SUPPLYBUYCALC3 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYBUYCALC3,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYBUYCALC3)
    //                       WHEN tg.SUPPLYBUYCALC3 IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.SUPPLYBUYCALC3)
    //          END ,
    //          u.SUPPLYORDERFORM3 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYORDERFORM3,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYORDERFORM3)
    //                       WHEN tg.SUPPLYORDERFORM3 IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.SUPPLYORDERFORM3)
    //          END ,
    //          u.SUPPLYTRANSCOSTYN3 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYTRANSCOSTYN3,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYTRANSCOSTYN3)
    //                       WHEN tg.SUPPLYTRANSCOSTYN3 IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.SUPPLYTRANSCOSTYN3)
    //          END ,
    //          u.SUPPLYTRANSCOSTVAT3 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYTRANSCOSTVAT3,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.SUPPLYTRANSCOSTVAT3)
    //                       WHEN tg.SUPPLYTRANSCOSTVAT3 IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.SUPPLYTRANSCOSTVAT3)
    //          END ,
    //          u.SUPPLYGOODSDISTRDUE3 =
    //          CASE
    //                       WHEN REPLACE(tg.SUPPLYGOODSDISTRDUE3,' ' ,'') <> '.'
    //                       THEN TO_NUMBER( tg.SUPPLYGOODSDISTRDUE3)
    //                       WHEN tg.SUPPLYGOODSDISTRDUE3 IS NULL
    //                       THEN NULL
    //                       ELSE TO_NUMBER(u.SUPPLYGOODSDISTRDUE3)
    //          END ,
    //          u.DELIVERYGUBUN =
    //          CASE
    //                       WHEN REPLACE(tg.DELIVERYGUBUN,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.DELIVERYGUBUN)
    //                       ELSE TO_NUMBER(u.DELIVERYGUBUN)
    //          END ,
    //          u.DELIVERYCOSTGUBUN =
    //          CASE
    //                       WHEN REPLACE(tg.DELIVERYCOSTGUBUN,' ' ,'') <> '.'
    //                       THEN TO_NUMBER(tg.DELIVERYCOSTGUBUN)
    //                       ELSE TO_NUMBER(u.DELIVERYCOSTGUBUN)
    //          END ,
    //          u.DELIVERYCOST_CODE =
    //          CASE
    //                       WHEN REPLACE(tg.DELIVERYCOST_CODE,' ' ,'') <> '.'
    //                       THEN tg.DELIVERYCOST_CODE
    //                       ELSE u.DELIVERYCOST_CODE
    //          END ,
    //          u.UPDATEDATE = SYSDATE
    //        ";
    //    using (OracleTransaction trans = connection.BeginTransaction())
    //    {
    //        logger.Debug("임시테이블 에서 실제 테이블 데이터 넣기 시작");
    //        command.CommandText = updateCommand;
    //        command.ExecuteNonQuery();
    //        trans.Commit();   //커밋
    //        logger.Debug("임시테이블 에서 실제 테이블 데이터 넣기 끝");
    //    }

    //}
    protected void btnExcelFormDownload_Click(object sender, EventArgs e)
    {
        string uploadFolderServerPath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
        string fileName = "우리안 기존상품 업로드폼.xlsx";
        string fileFullPath = uploadFolderServerPath + "Form\\" + fileName;

        FileHelper.FileDownload(this.Page, fileFullPath, fileName);
    }

    //이미지 삭제
    protected void click_Delete(object sender, EventArgs e)
    {
        
    }


    
}