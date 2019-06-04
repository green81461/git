using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using NLog;

public partial class Board_ComparePWD : System.Web.UI.Page
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

        string strPwd = Request["TextPwd"];
        string userPwd = Request["UserPwd"];

        ComparePwd(strPwd, userPwd);
    }

   
    protected void ComparePwd(string txtPwd, string userPwd)
    {
        HttpContext.Current.Response.ContentType = "text/json";
        string returnValue = string.Empty;
        string cryptPwd = string.Empty;
        if (!String.IsNullOrEmpty(txtPwd))
        {
            cryptPwd = Crypt.MD5Encryption(txtPwd);
        }
        if (cryptPwd == userPwd)
        {
            returnValue = "true";
        }
        else
        {
            returnValue = "false";
        }

        HttpContext.Current.Response.Write(returnValue);
    }
}