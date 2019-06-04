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

    
    //protected void btnExcelFormDownload_Click(object sender, EventArgs e)
    //{
    //    string uploadFolderServerPath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
    //    string fileName = "우리안 기존상품 업로드폼.xlsx";
    //    string fileFullPath = uploadFolderServerPath + "Form\\" + fileName;

    //    FileHelper.FileDownload(this.Page, fileFullPath, fileName);
    //}

    


    
}