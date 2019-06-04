using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Oracle.ManagedDataAccess.Client;   //이거안해줘서 오류가 났었다.
using System.Data; // dataset을 사용하기 위한.
using System.Configuration;
using System.Data.SqlClient;

public partial class Admin_imageUpload : System.Web.UI.Page
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




    // string dir = @"D:\우리안이미지\동신이미지\일반";
    // string dir = @"\\210.121.204.28\e$\web\urian\UploadFile\Goods\20180608추가";

    // string dir = @"C:\Users\JBPC3\Desktop\동신수동이미지 완료본\새 폴더 (3)\output 500(re)";
    string UploadFolder = @"D:\urian0830";
    // string saveFolder = @"D:\dd";
    string saveFolder = @"\\210.121.204.28\e$\web\urian\UploadFile\Goods";
    protected void Page_Load(object sender, EventArgs e)
    {
    }


    protected void btnUploaded_Click(object sender, EventArgs e)
    {
        lblUpload.Text = "이미지 업로드 작업 시작.";
        if (rdBtn1.Checked == true)
        {
            DirectoryInfo di = new DirectoryInfo(UploadFolder);
            FileInfo[] files = di.GetFiles("*.*");

            //해당 폴더의 값들을 배열로 받음.
            // DirectoryInfo[] diArr = di.GetDirectories();
            //정렬함.
            Array.Sort<FileInfo>(files, delegate (FileInfo x, FileInfo y) { return x.LastWriteTime.CompareTo(y.LastWriteTime); });


            Array.Reverse(files);

            for (int i = 0; i < files.Length; i++)
            {
                string FileAddress = files[i].FullName;
                string FileName = files[i].Name;

                // upload(File1.PostedFile.FileName, File1.FileName);
                string ftpServerIP = "ftp://210.121.204.207:21";
                //  string dir = @"D:\FTP\";
                string ftpUserID = "dstool";
                string ftpPassword = "dsds";

                //administrator
                //   Ehdghkrlrhdtk! goods 안에 upload 폴더 만들고.

                ////////////////////////////////////////////////////////////////////////
                string forder = FileName;                       //forder 변수에 Filename 넣음.
                char sp = '_';                                  //sp 라는 변수생성 후 구분값 _ 를 넣음.
                char Extension = '.';
                string[] spstring = forder.Split(sp);           //배열변수 spstring에 forder에서 sp를 자른 값을 넣음.
                string underbar = @"\";

                string[] fExtension = spstring[3].Split(Extension);
                DirectoryInfo dinfo = new DirectoryInfo(UploadFolder);

                DirectoryInfo dinfo1 = new DirectoryInfo(dinfo + spstring[0]); //1번경로
                DirectoryInfo dinfo2 = new DirectoryInfo(dinfo + spstring[0] + underbar + spstring[1]); //2번경로 
                DirectoryInfo dinfo3 = new DirectoryInfo(dinfo + spstring[0] + underbar + spstring[1] + underbar + spstring[2]); //3번경로
                DirectoryInfo dinfo4 = new DirectoryInfo(dinfo + spstring[0] + underbar + spstring[1] + underbar + spstring[2] + underbar + fExtension[0]); //4번경로

                //실제 저장될 파일 이름 "/"
                // DirectoryInfo dinfo5 = new DirectoryInfo(spstring[0] + underbar + spstring[1] + underbar + spstring[2] + underbar + fExtension[0]);
                DirectoryInfo dinfo5 = new DirectoryInfo(spstring[0] + underbar + spstring[1] + underbar + spstring[2]);
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
                //if (!dinfo4.Exists)
                //{
                //    dinfo4.Create();
                //}

                else
                {
                    lblUpload.Visible = true;
                    lblUpload.Text = "값이 없어용";
                }

                ////////////////////////////////////////////////////////////////////////


                FileInfo fileInf = new FileInfo(FileAddress);
                string uri = ftpServerIP + "/" + fileInf.Name; //fileinf = 업로드 파일의 실제경로

                FtpWebRequest reqFTP;

                // Create FtpWebRequest object from the Uri provided
                //  reqFTP = (FtpWebRequest)FtpWebRequest.Create(new Uri(ftpServerIP + "/" + fileInf.Name));
                reqFTP = (FtpWebRequest)FtpWebRequest.Create(new Uri(ftpServerIP + "/" + dinfo5 + "/" + fileInf.Name)); //FTP서버의 / / 넘겨받을 파일 제목

                // Provide the WebPermission Credintials
                reqFTP.Credentials = new NetworkCredential(ftpUserID, ftpPassword);

                // By default KeepAlive is true, where the control connection is 
                // not closed after a command is executed.
                reqFTP.KeepAlive = false;

                // Specify the command to be executed.
                reqFTP.Method = WebRequestMethods.Ftp.UploadFile;

                // Specify the data transfer type.
                reqFTP.UseBinary = true;

                // Notify the server about the size of the uploaded file
                reqFTP.ContentLength = fileInf.Length;

                // The buffer size is set to 2kb
                int buffLength = 2048;
                byte[] buff = new byte[buffLength];
                int contentLen;


                //여기서 저장하는듯 함!!!!!!!!!!
                // Opens a file stream (System.IO.FileStream) to read 
                //the file to be uploaded
                FileStream fs = fileInf.OpenRead();

                try
                {
                    // Stream to which the file to be upload is written
                    Stream strm = reqFTP.GetRequestStream();

                    // Read from the file stream 2kb at a time
                    contentLen = fs.Read(buff, 0, buffLength);

                    // Till Stream content ends
                    while (contentLen != 0)
                    {
                        // Write Content from the file stream to the 
                        // FTP Upload Stream
                        strm.Write(buff, 0, contentLen);
                        contentLen = fs.Read(buff, 0, buffLength);
                    }

                    // Close the file stream and the Request Stream
                    strm.Close();
                    fs.Close();
                }
                catch (Exception ex)
                {
                    Response.Write(ex.Message);
                }

                imgUpload(spstring[0], spstring[1], spstring[2]);


            }

        }

        ////////////////////////////////////////////여기부터 라디오2 폴더저장
        else if (rdBtn2.Checked == true)
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


                if (spstring[2].Contains("@") == true)
                {
                    string[] caretString = spstring[2].Split(caret);
                    caretString[0] = caretString[0].Replace('A', ' ');          //ex 000001
                    caretString[1] = caretString[1].Replace('A', ' ');          //ex 000030  

                    int caretA = Convert.ToInt32(caretString[0]);            //ex 1
                    int caretB = Convert.ToInt32(caretString[1]);            //ex 2

                    for (int a = caretA; a <= caretB; a++)
                    {
                        spstring[2] = "A" + a.ToString("D6");

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

                        ////////////////////////////////////////////////////////////////////////


                        FileInfo fileInf = new FileInfo(FileAddress);
                        //  string uri = dinfo + fileInf.Name; //fileinf = 업로드 파일의 실제경로 




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

                        imgUpload(spstring[0], spstring[1], spstring[2]);

                    }

                }
                else
                {

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

                    ////////////////////////////////////////////////////////////////////////


                    FileInfo fileInf = new FileInfo(FileAddress);
                    //  string uri = dinfo + fileInf.Name; //fileinf = 업로드 파일의 실제경로 




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

                    imgUpload(spstring[0], spstring[1], spstring[2]);


                }
            }
        }

        else
        {
            MessageBox.Show("항목을 선택해주세요", this);
        }
    }

    public void imgUpload(string aaaa, string bbbb, string cccc)
    {
        string oradb;
        oradb = "User Id=urian;Password=dsurian7;Data Source=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=210.121.204.13)(PORT=1539)))(CONNECT_DATA=(SERVICE_NAME=urian)(CID=(PROGRAM=C:\\Program?Files\\SQLTools?1.5\\SQLTools.exe)(HOST=DESKTOP-AKIQ2G3)(USER=JBPC3)))); ";
        //oradb = "User Id=urian;Password=urianc#;Data Source=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=210.121.204.206)(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=DSVINAt)(CID=(PROGRAM=C:\\Program?Files\\SQLTools?1.5\\SQLTools.exe)(HOST=DESKTOP-AKIQ2G3)(USER=JBPC3)))); ";
        string FileName = aaaa + '-' + bbbb + '-' + cccc + '-';
        string jpg = ".jpg";
        OracleConnection conn = new OracleConnection(oradb);

        conn.Open();

        OracleCommand cmd = new OracleCommand();
        cmd.Connection = conn;
        //   cmd.CommandText = "MERGE INTO U_GOODS_IMAGE USING DUAL ON (GoodsFinalCategoryCode='" + aaaa + "' and GoodsGroupCode ='" + bbbb + "' AND GoodsCode ='" + cccc + "') WHEN MATCHED THEN UPDATE SET  GoodsImgMainD = '" + FileName + "GoodsImgMainD" + jpg + "',GoodsImgMainE = '" + FileName + "GoodsImgMainE" + jpg + "',GoodsImgDetail1 = '" + FileName + "GoodsImgDetail1" + jpg + "' ,GoodsImgDetail2 = '" + FileName + "GoodsImgDetail2" + jpg + "' ,GoodsImgDetail3 = '" + FileName + "GoodsImgDetail3" + jpg + "' ,GoodsImgDetail4 = '" + FileName + "GoodsImgDetail4" + jpg + "'  WHEN NOT MATCHED THEN  INSERT (GoodsFinalCategoryCode,GoodsGroupCode,GoodsCode,GoodsImgMainD,GoodsImgMainE,GoodsImgDetail1,GoodsImgDetail2,GoodsImgDetail3,GoodsImgDetail4,EntryDate) VALUES ('" + aaaa + "','" + bbbb + "','" + cccc + "','" + FileName + "GoodsImgMainD" + jpg + "','" + FileName + "GoodsImgMainE" + jpg + "','" + FileName + "GoodsImgDetail1" + jpg + "','" + FileName + "GoodsImgDetail2" + jpg + "','" + FileName + "GoodsImgDetail3" + jpg + "','" + FileName + "GoodsImgDetail4" + jpg + "',SYSDATE)";


        //전부 소문자로 바꿈
        cmd.CommandText = "MERGE INTO U_GOODS_IMAGE USING DUAL ON (GoodsFinalCategoryCode='" + aaaa + "' and GoodsGroupCode ='" + bbbb + "' AND GoodsCode ='" + cccc + "') WHEN MATCHED THEN UPDATE SET  GoodsImgMainD = '" + FileName + "goodsimgmaind" + jpg + "',GoodsImgMainE = '" + FileName + "goodsimgmaine" + jpg + "',GoodsImgDetail1 = '" + FileName + "goodsimgdetail1" + jpg + "' ,GoodsImgDetail2 = '" + FileName + "goodsimgdetail2" + jpg + "' ,GoodsImgDetail3 = '" + FileName + "goodsimgdetail3" + jpg + "' ,GoodsImgDetail4 = '" + FileName + "goodsimgdetail4" + jpg + "'  WHEN NOT MATCHED THEN  INSERT (GoodsFinalCategoryCode,GoodsGroupCode,GoodsCode,GoodsImgMainD,GoodsImgMainE,GoodsImgDetail1,GoodsImgDetail2,GoodsImgDetail3,GoodsImgDetail4,EntryDate) VALUES ('" + aaaa + "','" + bbbb + "','" + cccc + "','" + FileName + "goodsimgmaind" + jpg + "','" + FileName + "goodsimgmaine" + jpg + "','" + FileName + "goodsimgdetail1" + jpg + "','" + FileName + "goodsimgdetail2" + jpg + "','" + FileName + "goodsimgdetail3" + jpg + "','" + FileName + "goodsimgdetail4" + jpg + "',SYSDATE)";


        cmd.ExecuteNonQuery();
        conn.Close();

    }
    //실 FTP

}

