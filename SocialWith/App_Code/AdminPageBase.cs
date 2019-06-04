using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Urian.Core;
using SocialWith.Data.User;
using NLog;

/// <summary>
/// AdminPageBase의 요약 설명입니다.
/// </summary>
public class AdminPageBase : System.Web.UI.Page
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
    public AdminPageBase()
    {
        this.Load += new EventHandler(this.Page_PreInit);
    }

    protected void Page_PreInit(object sender, EventArgs e)
    {
        if ((Request.Cookies["Admin_LoginID"] == null) || (Request.Cookies["Admin_Svid_User"] == null))
        {
            HttpContext.Current.Response.Redirect("~/Admin/Login.aspx");
            HttpContext.Current.Response.End();
        }
    }

    //로그인 계정 아이디(세션)
    private string _adminId;
    public string AdminId
    {
        get
        {

            if (Request.Cookies["Admin_LoginID"] != null && Request.Cookies["Admin_LoginID"].Value.ToString().Length > 0)
            {
                return _adminId = Request.Cookies["Admin_LoginID"].Value.ToString();
            }
            else
            {
                return string.Empty;
            }
        }
        set
        {
            _adminId = value;
        }
    }

    private string _svid_user;
    public string Svid_User
    {
        get
        {

            if (Request.Cookies["Admin_Svid_User"] != null && Request.Cookies["Admin_Svid_User"].Value.ToString().Length > 0)
            {
                return _svid_user = Request.Cookies["Admin_Svid_User"].Value.ToString();
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
            if (!string.IsNullOrWhiteSpace(AdminId))
            {
                var paramList = new Dictionary<string, object>() {
                    {"nvar_P_ID", AdminId}
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

    private string _siteName;
    public string SiteName
    {
        get
        {
            string url = HttpContext.Current.Request.Url.Host;
            if (url.Trim().StartsWith("www"))
            {
                url = url.Trim().Split('.')[1];
            }
            else
            {
                url = url.Trim().Split('.')[0];
            }

            return _siteName = url;
        }
        set
        {
            _siteName = value;
        }
    }
}