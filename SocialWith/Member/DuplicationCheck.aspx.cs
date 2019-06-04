using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.User;

public partial class Member_DuplicationCheck : System.Web.UI.Page
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
        string strId = Request["TextId"];
        DuplicationCheck(strId);
    }

    protected void DuplicationCheck(string id)
    {
        HttpContext.Current.Response.ContentType = "text/json";
        string returnValue = string.Empty;

        var service = new UserService();
        var paramList = new Dictionary<string, object>() {
            {"nvar_P_ID", id}
        };
        var user = service.LoginIdCheck(paramList);
        if (user != null)
        {
            returnValue = "false";
        }
        else
        {
            returnValue = "true";
        }

        HttpContext.Current.Response.Write(returnValue);
    }
}