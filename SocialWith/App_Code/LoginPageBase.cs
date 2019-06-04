using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SocialWith.Biz.DistCss;
using SocialWith.Data.DistCSS;
using NLog;
using System.Configuration;
using Urian.Core;
/// <summary>
/// LoginPageBase의 요약 설명입니다.
/// </summary>
public class LoginPageBase : System.Web.UI.Page
{
    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion
    protected DistCssService distCssService = new DistCssService();
    public LoginPageBase()
    {
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

    private DistCssInfo _distCss;
    public DistCssInfo DistCssObject
    {
        get
        {
            string url = HttpContext.Current.Request.Url.Host;
            var paramList = new Dictionary<string, object>() {
                    { "nvar_P_URL", url},
                    { "nvar_P_SALECOMPCODE","EMPTY"},
                    { "nvar_P_BUYCOMPCODE", "EMPTY"},
                };
            return _distCss = distCssService.GetSiteDistCssInfo(paramList);
        }
        set
        {
            _distCss = value;
        }
    }
    
}