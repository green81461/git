using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Urian.Core;
using SocialWith.Data.User;
using NLog;

/// <summary>
/// AdminSubPageBase의 요약 설명입니다.
/// </summary>
public class AdminSubPageBase : System.Web.UI.Page
{
    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    protected SocialWith.Biz.User.UserService service = new SocialWith.Biz.User.UserService();

    public AdminSubPageBase()
    {
        this.Load += new EventHandler(this.Page_PreInit);
    }

    protected void Page_PreInit(object sender, EventArgs e)
    {
        if ((Request.Cookies["AdminSub_LoginID"] == null) || (Request.Cookies["AdminSub_Svid_User"] == null))
        {
            HttpContext.Current.Response.Redirect("~/Member/Login.aspx");
            HttpContext.Current.Response.End();
        }
    }
    //로그인 계정 아이디(세션)
    private string _userId;
    public string UserId
    {
        get
        {

            if (Request.Cookies["AdminSub_LoginID"] != null && Request.Cookies["AdminSub_LoginID"].Value.ToString().Length > 0)
            {
                return _userId = Request.Cookies["AdminSub_LoginID"].Value.ToString();
            }
            else
            {
                return string.Empty;
            }
        }
        set
        {
            _userId = value;
        }
    }

    private string _svid_user;
    public string Svid_User
    {
        get
        {

            if (Request.Cookies["AdminSub_Svid_User"] != null && Request.Cookies["AdminSub_Svid_User"].Value.ToString().Length > 0)
            {
                return _svid_user = Request.Cookies["AdminSub_Svid_User"].Value.ToString();
            }
            else
            {
                return string.Empty;
            }
        }
        set
        {
            _svid_user = value;
        }
    }

    private UserDTO _user;
    public UserDTO UserInfoObject
    {
        get
        {
            if (!string.IsNullOrWhiteSpace(UserId))
            {
                var paramList = new Dictionary<string, object>() {
                    {"nvar_P_ID", UserId}
                };
                return _user = service.GetUser(paramList);
            }
            else
            {
                return null;
            }
        }
        set
        {
            _user = value;
        }
    }
}