using NLog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.User;

public partial class Order_FileDownload : NonAuthenticationPageBase
{
    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        string filePath = Request["FilePath"];
        string fileName = Request["FileName"];

        string uploadFolderServerPath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
        string fileFullPath = string.Empty;
        if (!String.IsNullOrEmpty(fileName) && !String.IsNullOrEmpty(filePath))
        {

            fileFullPath = uploadFolderServerPath + filePath + fileName;

            if (File.Exists(fileFullPath))
            {

                Page.Response.HeaderEncoding = System.Text.Encoding.Default;
                Page.Response.Charset = "utf-8";
                Page.Response.ContentType = "application/octet-stream";
                Page.Response.AppendHeader("Content-Disposition", String.Format("attachment; filename=\"{0}\"", HttpUtility.UrlEncode(fileName, System.Text.Encoding.UTF8).Replace("+", "%20")));
                Page.Response.WriteFile(fileFullPath);
                Page.Response.End();
            }
            else
            {
                Page.Response.Write("<script>alert('파일다운로드 오류'); location.href='" + HttpContext.Current.Request.UrlReferrer.ToString() + "';</script>");
                Page.Response.End();
            }
        }
    }
 }