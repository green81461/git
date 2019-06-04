using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
//using Oracle.DataAccess.Client;   //이거안해줘서 오류가 났었다.
using Oracle.ManagedDataAccess.Client;
using System.Data; // dataset을 사용하기 위한.
using System.Configuration;
using System.Data.SqlClient;

public partial class Admin_Goods_ImageUpload : System.Web.UI.Page
{
    public static class MessageBox
    {
        public static void Show(String message, Page page)
        {
            page.ClientScript.RegisterStartupScript(page.GetType(), "MessageBox", "alert(\"" + message + "\");", true);
        }

        internal static void Show(string v)
        {
            throw new NotImplementedException();
        }
    }


    string UploadFolder = @"D:\Goods\BaseFolder";
    // string saveFolder = @"D:\dd";
    //string saveFolder = @"Y:\SocialWith\UploadFile\GoodsImages";          //업로드 될 폴더, 수정 X
    //string saveFolder = @"D:\Svn\SocialWith\SocialWith\UploadFile\GoodsImages";         //업로드 될 폴더, 수정 X
    string saveFolder = @"D:\Goods\TargetFolder";         //업로드 될 폴더, 수정 X
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void btnUpload_Click(object sender, EventArgs e)
    {
        //해당 폴더의 값들을 배열로 받음.
        DirectoryInfo di = new DirectoryInfo(UploadFolder);
        FileInfo[] files = di.GetFiles("*.jpg");

        //정렬함.
        Array.Sort<FileInfo>(files, delegate (FileInfo x, FileInfo y) { return x.LastWriteTime.CompareTo(y.LastWriteTime); });





        //정렬할걸 전체 뒤집어서 원 순서대로 바꿈.
        Array.Reverse(files);


        for (int i = 0; i < files.Length; i++)
        {
            string FileAddress = files[i].FullName;
            string FileName = files[i].Name;

            ////////////////////////////////////////////////////////////////////////
            string forder = FileName;                       //forder 변수에 Filename 넣음.
            char sp = '-';                                  //sp 라는 변수생성 후 구분값 _ 를 넣음.
            char Extension = '.';
            string[] spstring = forder.Split(sp);           //배열변수 spstring에 forder에서 sp를 자른 값을 넣음.
            string underbar = @"\";
            char caret = '@';

            string[] fExtension = spstring[3].Split(Extension);
            fExtension[0] = fExtension[0].Replace('#', '_');
            DirectoryInfo dinfo = new DirectoryInfo(saveFolder + underbar);

            DirectoryInfo dinfo1 = new DirectoryInfo(dinfo + spstring[0]); //1번경로
            DirectoryInfo dinfo2 = new DirectoryInfo(dinfo + spstring[0] + underbar + spstring[1]); //2번경로 
            DirectoryInfo dinfo3 = new DirectoryInfo(dinfo + spstring[0] + underbar + spstring[1] + underbar + spstring[2]); //3번경로
            DirectoryInfo dinfo4 = new DirectoryInfo(dinfo + spstring[0] + underbar + spstring[1] + underbar + spstring[2] + underbar + fExtension[0]); //4번경로

            //실제 저장될 파일 이름
            // DirectoryInfo dinfo5 = new DirectoryInfo(spstring[0] + underbar + spstring[1] + underbar + spstring[2] + underbar + fExtension[0]);
            DirectoryInfo dinfo6 = new DirectoryInfo(dinfo + spstring[0] + underbar + spstring[1] + underbar + spstring[2] + underbar + spstring[0] + "-" + spstring[1] + "-" + spstring[2] + "-" + fExtension[0]);

            DirectoryInfo dinfo5 = new DirectoryInfo(dinfo + spstring[0] + "-" + spstring[1] + "-" + spstring[2] + "-" + fExtension[0]);
            if (!dinfo1.Exists)
            {
                dinfo1.Create();
                // DirectoryInfo dinfo2 = new DirectoryInfo(dinfo + spstring[0] + underbar + spstring[1]);
            }
            if (!dinfo2.Exists)
            {
                dinfo2.Create();
            }
            if (!dinfo3.Exists)
            {
                dinfo3.Create();
            }
            else
            {
                lblUpload.Visible = true;
                lblUpload.Text = "이미지 업로드 완료.";
            }

            FileInfo fileInf = new FileInfo(FileAddress);



            // The buffer size is set to 2kb
            int buffLength = 2048;
            byte[] buff = new byte[buffLength];

            try
            {

                fileInf.CopyTo(@"" + dinfo6 + ".jpg ", true);
            }
            catch (Exception ex)
            {
                Response.Write(ex.Message);
            }

           // imgUpload(spstring[0], spstring[1], spstring[2]);

            //if (spstring[2].Contains("@") == true)
            //{
            //    string[] caretString = spstring[2].Split(caret);
            //    caretString[0] = caretString[0].Replace('A', ' ');          //ex 000001
            //    caretString[1] = caretString[1].Replace('A', ' ');          //ex 000030  

            //    int caretA = Convert.ToInt32(caretString[0]);            //ex 1
            //    int caretB = Convert.ToInt32(caretString[1]);            //ex 2

            //    for (int a = caretA; a <= caretB; a++)
            //    {
            //        spstring[2] = "A" + a.ToString("D6");

            //        string[] fExtension = spstring[3].Split(Extension);
            //        fExtension[0] = fExtension[0].Replace('#', '_');
            //        DirectoryInfo dinfo = new DirectoryInfo(saveFolder + underbar);

            //        DirectoryInfo dinfo1 = new DirectoryInfo(dinfo + spstring[0]); //1번경로
            //        DirectoryInfo dinfo2 = new DirectoryInfo(dinfo + spstring[0] + underbar + spstring[1]); //2번경로 
            //        DirectoryInfo dinfo3 = new DirectoryInfo(dinfo + spstring[0] + underbar + spstring[1] + underbar + spstring[2]); //3번경로
            //        DirectoryInfo dinfo4 = new DirectoryInfo(dinfo + spstring[0] + underbar + spstring[1] + underbar + spstring[2] + underbar + fExtension[0]); //4번경로

            //        //실제 저장될 파일 이름
            //        // DirectoryInfo dinfo5 = new DirectoryInfo(spstring[0] + underbar + spstring[1] + underbar + spstring[2] + underbar + fExtension[0]);
            //        DirectoryInfo dinfo6 = new DirectoryInfo(dinfo + spstring[0] + underbar + spstring[1] + underbar + spstring[2] + underbar + spstring[0] + "-" + spstring[1] + "-" + spstring[2] + "-" + fExtension[0]);



            //        DirectoryInfo dinfo5 = new DirectoryInfo(dinfo + spstring[0] + "-" + spstring[1] + "-" + spstring[2] + "-" + fExtension[0]);
            //        if (!dinfo1.Exists)
            //        {
            //            dinfo1.Create();
            //            // DirectoryInfo dinfo2 = new DirectoryInfo(dinfo + spstring[0] + underbar + spstring[1]);
            //        }
            //        if (!dinfo2.Exists)
            //        {
            //            dinfo2.Create();
            //        }
            //        if (!dinfo3.Exists)
            //        {
            //            dinfo3.Create();
            //        }
            //        else
            //        {
            //            lblUpload.Visible = true;
            //            lblUpload.Text = "이미지 업로드 완료.";
            //        }

            //        ////////////////////////////////////////////////////////////////////////


            //        FileInfo fileInf = new FileInfo(FileAddress);
            //        //  string uri = dinfo + fileInf.Name; //fileinf = 업로드 파일의 실제경로 




            //        // The buffer size is set to 2kb
            //        int buffLength = 2048;
            //        byte[] buff = new byte[buffLength];

            //        try
            //        {

            //            fileInf.CopyTo(@"" + dinfo6 + ".jpg ", true);
            //        }
            //        catch (Exception ex)
            //        {
            //            Response.Write(ex.Message);
            //        }

            //        imgUpload(spstring[0], spstring[1], spstring[2]);

            //    }

            //}
            //else
            //{

            //    string[] fExtension = spstring[3].Split(Extension);
            //    fExtension[0] = fExtension[0].Replace('#', '_');
            //    DirectoryInfo dinfo = new DirectoryInfo(saveFolder + underbar);

            //    DirectoryInfo dinfo1 = new DirectoryInfo(dinfo + spstring[0]); //1번경로
            //    DirectoryInfo dinfo2 = new DirectoryInfo(dinfo + spstring[0] + underbar + spstring[1]); //2번경로 
            //    DirectoryInfo dinfo3 = new DirectoryInfo(dinfo + spstring[0] + underbar + spstring[1] + underbar + spstring[2]); //3번경로
            //    DirectoryInfo dinfo4 = new DirectoryInfo(dinfo + spstring[0] + underbar + spstring[1] + underbar + spstring[2] + underbar + fExtension[0]); //4번경로

            //    //실제 저장될 파일 이름
            //    // DirectoryInfo dinfo5 = new DirectoryInfo(spstring[0] + underbar + spstring[1] + underbar + spstring[2] + underbar + fExtension[0]);
            //    DirectoryInfo dinfo6 = new DirectoryInfo(dinfo + spstring[0] + underbar + spstring[1] + underbar + spstring[2] + underbar + spstring[0] + "-" + spstring[1] + "-" + spstring[2] + "-" + fExtension[0]);

            //    DirectoryInfo dinfo5 = new DirectoryInfo(dinfo + spstring[0] + "-" + spstring[1] + "-" + spstring[2] + "-" + fExtension[0]);
            //    if (!dinfo1.Exists)
            //    {
            //        dinfo1.Create();
            //        // DirectoryInfo dinfo2 = new DirectoryInfo(dinfo + spstring[0] + underbar + spstring[1]);
            //    }
            //    if (!dinfo2.Exists)
            //    {
            //        dinfo2.Create();
            //    }
            //    if (!dinfo3.Exists)
            //    {
            //        dinfo3.Create();
            //    }
            //    else
            //    {
            //        lblUpload.Visible = true;
            //        lblUpload.Text = "이미지 업로드 완료.";
            //    }

            //    FileInfo fileInf = new FileInfo(FileAddress);



            //    // The buffer size is set to 2kb
            //    int buffLength = 2048;
            //    byte[] buff = new byte[buffLength];

            //    try
            //    {

            //        fileInf.CopyTo(@"" + dinfo6 + ".jpg ", true);
            //    }
            //    catch (Exception ex)
            //    {
            //        Response.Write(ex.Message);
            //    }

            //    imgUpload(spstring[0], spstring[1], spstring[2]);

            //}
        }

    }


    public void imgUpload(string GoodsFinalCategoryCode, string GoodsGroupCode, string GoodsCode)
    {
        string oradb;
        oradb = "User Id=urian;Password=dsurian7;Data Source=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=210.121.204.13)(PORT=1539)))(CONNECT_DATA=(SERVICE_NAME=urian)(CID=(PROGRAM=C:\\Program?Files\\SQLTools?1.5\\SQLTools.exe)(HOST=DESKTOP-AKIQ2G3)(USER=JBPC3)))); ";
        //oradb = "User Id=urian;Password=urianc#;Data Source=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=210.121.204.206)(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=DSVINAt)(CID=(PROGRAM=C:\\Program?Files\\SQLTools?1.5\\SQLTools.exe)(HOST=DESKTOP-AKIQ2G3)(USER=JBPC3)))); ";
        string FileName = GoodsFinalCategoryCode + '-' + GoodsGroupCode + '-' + GoodsCode + '-';
        string jpg = ".jpg";
        OracleConnection conn = new OracleConnection(oradb);

        conn.Open();

        OracleCommand cmd = new OracleCommand();
        cmd.Connection = conn;

        //전부 소문자로 바꿈
        cmd.CommandText = "MERGE INTO U_GOODS_IMAGE USING DUAL ON (GoodsFinalCategoryCode='" + GoodsFinalCategoryCode + "' and GoodsGroupCode ='" + GoodsGroupCode + "' AND GoodsCode ='" + GoodsCode + "') WHEN MATCHED THEN UPDATE SET  GoodsImgMainD = '" + FileName + "goodsimgmaind" + jpg + "',GoodsImgMainE = '" + FileName + "goodsimgmaine" + jpg + "',GoodsImgDetail1 = '" + FileName + "goodsimgdetail1" + jpg + "' ,GoodsImgDetail2 = '" + FileName + "goodsimgdetail2" + jpg + "' ,GoodsImgDetail3 = '" + FileName + "goodsimgdetail3" + jpg + "' ,GoodsImgDetail4 = '" + FileName + "goodsimgdetail4" + jpg + "'  WHEN NOT MATCHED THEN  INSERT (GoodsFinalCategoryCode,GoodsGroupCode,GoodsCode,GoodsImgMainD,GoodsImgMainE,GoodsImgDetail1,GoodsImgDetail2,GoodsImgDetail3,GoodsImgDetail4,EntryDate) VALUES ('" + GoodsFinalCategoryCode + "','" + GoodsGroupCode + "','" + GoodsCode + "','" + FileName + "goodsimgmaind" + jpg + "','" + FileName + "goodsimgmaine" + jpg + "','" + FileName + "goodsimgdetail1" + jpg + "','" + FileName + "goodsimgdetail2" + jpg + "','" + FileName + "goodsimgdetail3" + jpg + "','" + FileName + "goodsimgdetail4" + jpg + "',SYSDATE)";


        cmd.ExecuteNonQuery();
        conn.Close();

    }
    //실 FTP

}

