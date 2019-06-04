using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NLog;

/// <summary>
/// FileHelper의 요약 설명입니다.
/// </summary>
public class FileHelper
{
    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    public FileHelper()
    {
        //
        // TODO: 여기에 생성자 논리를 추가합니다.
        //
    }

    public static string UploadFileCheck(string strFilePath, string strFileName, int intFileMaxSize, int intFileSize)
    {
        bool blFileSize = false;
        if ((intFileMaxSize >= intFileSize) || (intFileMaxSize == 0))
        {
            blFileSize = true;
        }
        string strTempFileName = string.Empty;
        string strTempExtension = string.Empty;
        if (blFileSize)
        {
            try
            {
                int intFileReName = 0;
                if (File.Exists(strFilePath + strFileName))
                {
                    while (File.Exists(strFilePath + strFileName))
                    {
                        if (intFileReName == 0)
                        {
                            strTempFileName = strFileName.Substring(0, strFileName.LastIndexOf("."));
                            strTempExtension = strFileName.Replace(strTempFileName, "");
                            strFileName = strTempFileName + "_0" + strTempExtension;
                        }
                        else
                        {
                            strFileName = strTempFileName + "_" + intFileReName.ToString() + strTempExtension;
                        }
                        intFileReName++;
                    }
                }
            }
            catch
            {
                strFileName = "false";
            }
        }
        else
        {
            strFileName = "false";
        }
        if (strFileName.Length > 60)
        {
            strFileName = "false";
        }
        return strFileName;
    }

    public static string FileUpload(FileUpload fl_FileUpload, Page page, string strNowFileName, int intMaxSize, string userId, string type, string seq)
    {
        if (fl_FileUpload.HasFile)
        {
            int intFileSize = fl_FileUpload.PostedFile.ContentLength;
            string strFilePath = GetFileUploadPath(page, userId, type, seq);
            strNowFileName = UploadFileCheck(strFilePath, strNowFileName, intMaxSize, intFileSize);
            if (strNowFileName.Equals("false"))
            {
                HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                HttpContext.Current.Response.End();
                return strNowFileName;
            }
            fl_FileUpload.SaveAs(strFilePath + strNowFileName);
        }
        return strNowFileName;
    }

    //public static string AdminServerFileUpload(FileUpload fl_FileUpload, string strNowFileName, int intMaxSize, string userId, string type, string seq)
    //{
    //    if (fl_FileUpload.HasFile)
    //    {
    //        int intFileSize = fl_FileUpload.PostedFile.ContentLength;
    //        string strFilePath = GetAdminServerFileUploadPath(userId, type,seq);
    //        strNowFileName = UploadFileCheck(strFilePath, strNowFileName, intMaxSize, intFileSize);
    //        if (strNowFileName.Equals("false"))
    //        {
    //            HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
    //            HttpContext.Current.Response.End();
    //            return strNowFileName;
    //        }
    //        fl_FileUpload.SaveAs(strFilePath + strNowFileName);
    //    }
    //    return strNowFileName;
    //}

    public static string MuiltiFileUpload(HttpPostedFile postedFile, Page page,  string strNowFileName, int intMaxSize, string userId, string type, string seq)
    {
        int intFileSize = postedFile.ContentLength;
        string strFilePath = GetFileUploadPath(page, userId, type, seq);
        strNowFileName = UploadFileCheck(strFilePath, strNowFileName, intMaxSize, intFileSize);
        if (strNowFileName.Equals("false"))
        {
            HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
            HttpContext.Current.Response.End();
            return strNowFileName;
        }
        postedFile.SaveAs(strFilePath + strNowFileName);
        return strNowFileName;
    }

    //public static string AdminServerMuiltiFileUpload(HttpPostedFile postedFile, string strNowFileName, int intMaxSize, string userId, string type, string seq)
    //{
    //    int intFileSize = postedFile.ContentLength;
    //    string strFilePath = GetAdminServerFileUploadPath(userId, type, seq);
    //    strNowFileName = UploadFileCheck(strFilePath, strNowFileName, intMaxSize, intFileSize);
    //    if (strNowFileName.Equals("false"))
    //    {
    //        HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
    //        HttpContext.Current.Response.End();
    //        return strNowFileName;
    //    }
    //    postedFile.SaveAs(strFilePath + strNowFileName);
    //    return strNowFileName;
    //}


    public static void FileDownload(Page page,  string fullPath, string fileName)
    {
        if (File.Exists(fullPath))
        {
            
            page.Response.HeaderEncoding = System.Text.Encoding.Default;
            page.Response.Charset = "utf-8";
            page.Response.ContentType = "application/octet-stream";
            page.Response.AppendHeader("Content-Disposition", String.Format("attachment; filename=\"{0}\"", HttpUtility.UrlEncode(fileName,System.Text.Encoding.UTF8).Replace("+", "%20")));
            page.Response.WriteFile(fullPath);
            page.Response.End();
        }
        else
        {
            HttpContext.Current.Response.Write("<script>alert('파일다운로드 오류'); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
            HttpContext.Current.Response.End();
        }
           
    }

    public static void CreateDirectory(string path)
    {
        var info = new DirectoryInfo(path);

        try
        {
            if (info.Exists == false)
            {
                info.Create();
            }
        }
        catch (IOException ie)
        {
            if (IsWarnEnabled)
            {
                logger.Warn("디렉토리를 생성하지 못했습니다. path={0} ex : {1}", path, ie);
            }

            throw;
        }
    }

    public static String GetFileUploadPath(Page page, string userId, string type, string seq)
    {
        try
        {
            var uploadVirtualPath = string.Empty;


            switch (type)
            {
                case "Board":
                    uploadVirtualPath = String.Format("{0}/{1}/{2}/{3}/"
                                                  , ConfigurationManager.AppSettings["UpLoadFolder"]
                                                  ,"Board"
                                                  , userId
                                                  , seq);
                    break;
                case "Notice":
                    uploadVirtualPath = String.Format("{0}/{1}/{2}/{3}/"
                                                  , ConfigurationManager.AppSettings["UpLoadFolder"]
                                                  , "Notice"
                                                  ,  userId
                                                  , seq);
                    break;
                case "MemberA":
                    uploadVirtualPath = String.Format("{0}/{1}/{2}/{3}/"
                                                  , ConfigurationManager.AppSettings["UpLoadFolder"]
                                                  , "Member"
                                                  , "A"
                                                  , userId);
                    break;
                case "MemberB":
                    uploadVirtualPath = String.Format("{0}/{1}/{2}/{3}/"
                                                 , ConfigurationManager.AppSettings["UpLoadFolder"]
                                                 , "Member"
                                                 , "B"
                                                 , userId);
                    break;
                case "AS":
                    uploadVirtualPath = String.Format("{0}/{1}/{2}/{3}/"
                                                  , ConfigurationManager.AppSettings["UpLoadFolder"]
                                                  , "AS"
                                                  , userId
                                                  , seq);
                    break;
                case "SystemUpdate":
                    uploadVirtualPath = String.Format("{0}/{1}/{2}/{3}/"
                                                  , ConfigurationManager.AppSettings["UpLoadFolder"]
                                                  , "System"
                                                  , userId
                                                  , seq);
                    break;
                case "NewGood":
                    uploadVirtualPath = String.Format("{0}/{1}/{2}/"
                                                  , ConfigurationManager.AppSettings["UpLoadFolder"]
                                                  , "NewGood"
                                                  , userId);
                    break;
                default:
                    uploadVirtualPath = String.Format("{0}/{1}/{2}/{3}/"
                                                 , ConfigurationManager.AppSettings["UpLoadFolder"]
                                                 , "Board"
                                                 , userId
                                                 , seq);
                    break;
            }

            var uploadPath = page.Server.MapPath(uploadVirtualPath);

            CreateDirectory(uploadPath);

            return uploadPath;
        }
        catch (Exception ex)
        {
            if (IsErrorEnabled)
            {
                logger.Error(ex, "파일 업로드 경로 설정 실패");
            }

            return String.Empty;
        }
    }

    public static String GetAdminServerFileUploadPath(string userId, string type, string seq)
    {
        try
        {
            var uploadPath = string.Empty;


            switch (type)
            {
                case "MemberA":
                    uploadPath = String.Format(@"{0}\{1}\{2}\{3}\"
                                                  , ConfigurationManager.AppSettings["UrianUpLoadFolder"]
                                                  , "Member"
                                                  , "A"
                                                  , userId);
                    break;
                case "MemberB":
                    uploadPath = String.Format(@"{0}\{1}\{2}\{3}\"
                                                  , ConfigurationManager.AppSettings["UrianUpLoadFolder"]
                                                  , "Member"
                                                  , "A"
                                                  , userId);
                    break;
            }
           
            CreateDirectory(uploadPath);

            return uploadPath;
        }
        catch (Exception ex)
        {
            if (IsErrorEnabled)
            {
                logger.Error(ex, "파일 업로드 경로 설정 실패");
            }

            return String.Empty;
        }
    }


    //파일 삭제
    public static void FileDelete(string filepath) {
        try
        {
            logger.Debug("filepath={0}", filepath);
            if (File.Exists(filepath))
            {
                logger.Debug("Exist!!!");
                using (var fw = new FileSystemWatcher(Path.GetDirectoryName(filepath), Path.GetFileName(filepath)))
                using (var mre = new ManualResetEventSlim())
                {
                    fw.EnableRaisingEvents = true;
                    fw.Deleted += (object sender, FileSystemEventArgs e) =>
                    {
                        mre.Set();
                    };
                    File.Delete(filepath);
                    logger.Debug("Delete Success!!!");
                    mre.Wait(30000);
                }

            }

            
        }
        catch (Exception ex)
        {
            logger.Error(ex, "ErrorMessage={0}");
        }
      
    }


    public static void CopyFolder(string sourceFolder, string destFolder)
    {
       

        if (!Directory.Exists(destFolder)) { 
            Directory.CreateDirectory(destFolder);
        }
        else
        {
            string[] destFiles = Directory.GetFiles(destFolder);
            foreach (string file in destFiles)
            {
                File.Delete(Path.Combine(destFolder, Path.GetFileName(file)));
            }

            Directory.Delete(destFolder);
            Directory.CreateDirectory(destFolder);
        }
        if (Directory.Exists(sourceFolder))
        {
            string[] files = Directory.GetFiles(sourceFolder);
            string[] folders = Directory.GetDirectories(sourceFolder);
            foreach (string file in files)
            {
                string name = Path.GetFileName(file);
                string dest = Path.Combine(destFolder, name);
                File.Copy(file, dest);
            }

            foreach (string folder in folders)
            {
                string name = Path.GetFileName(folder);
                string dest = Path.Combine(destFolder, name);
                CopyFolder(folder, dest);
            }
        }
        
    }
}