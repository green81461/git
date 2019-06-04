//using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Urian.Core;
using SocialWith.Data.User;
using NLog;
using SocialWith.Data.DistCSS;
using SocialWith.Biz.DistCss;
using SocialWith.Biz.User;
using System.Configuration;
/// <summary>
/// PageBase의 요약 설명입니다.
/// </summary>
public class PageBase : System.Web.UI.Page
{
    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    protected UserService service = new UserService();
    protected DistCssService distCssService = new DistCssService();
    public PageBase()
    {
       this.Load += new EventHandler(this.Page_PreInit);
    }

    protected void Page_PreInit(object sender, EventArgs e)
    {
        if (Request.Cookies["Svid_User"] == null)
        {
            HttpContext.Current.Response.Redirect("~/Member/Login.aspx");
        }
    }
    
    //로그인 계정 아이디(세션)
    private string _userId;
    public string UserId {
        get {

            if (Request.Cookies["LoginID"] != null && Request.Cookies["LoginID"].Value.ToString().Length > 0)
            {
                return _userId = Request.Cookies["LoginID"].Value.ToString();
            }
            else
            {
                return string.Empty;
            }
        } 
        set {
            _userId = value;
        } 
    }

    private string _svid_user;
    public string Svid_User
    {
        get
        {

            if (Request.Cookies["Svid_User"] != null && Request.Cookies["Svid_User"].Value.ToString().Length > 0)
            {
                return _svid_user = Request.Cookies["Svid_User"].Value.ToString();
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

    private DistCssInfo _distCss;
    public DistCssInfo DistCssObject
    {
        
        get
        {
            string url = HttpContext.Current.Request.Url.Host;
            string saleCompCode = UserInfoObject != null ? UserInfoObject.UserInfo.SaleCompCode.AsText() : "";
            string buyCompCode = UserInfoObject != null ? UserInfoObject.UserInfo.Company_Code.AsText() : "";
            var paramList = new Dictionary<string, object>() {
                    { "nvar_P_URL", url},
                    { "nvar_P_SALECOMPCODE",saleCompCode},
                    { "nvar_P_BUYCOMPCODE", buyCompCode},
                };
            return _distCss = distCssService.GetSiteDistCssInfo(paramList);
        }
        set
        {
            _distCss = value;
        }
    }
}