using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.DistCss;
using Urian.Core;

public partial class Master_Login : System.Web.UI.MasterPage
{
    string DistSSLConfirmYN = string.Empty;
    string PgConfirmYN = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        GetSiteDistCss();
        SiteRedirect();
    }

    protected void GetSiteDistCss()
    {

        DistCssService distCssService = new DistCssService();


        string url = Request.Url.Host;

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_URL", url},
            { "nvar_P_SALECOMPCODE","EMPTY"},
            { "nvar_P_BUYCOMPCODE", "EMPTY"},

        };

        var distInfo = distCssService.GetSiteDistCssInfo(paramList);
     

        if (distInfo == null)
        {
            DistSSLConfirmYN = "N";
            PgConfirmYN = "N";
        }
        else
        {
            DistSSLConfirmYN = distInfo.DistSSLConfirmYN;
            PgConfirmYN = distInfo.PgConfirmYN;
        }
    }

    protected void SiteRedirect()
    {
        string siteName = HttpContext.Current.Request.Url.Host;
        if (siteName.Trim().StartsWith("www"))
        {
            siteName = siteName.Trim().Split('.')[1];
        }
        else
        {
            siteName = siteName.Trim().Split('.')[0];
        }

        string scheme = DistSSLConfirmYN == "Y" ? "https" : "http";
        string host = Request.Url.Host;
        if (siteName == "socialex") //무한상사 구매사 도로공사용 도메인... 이걸로 접속하면 무한상사 도메인으로 페이지 이동
        {
            Response.Redirect(scheme + "://www.muhancoop.com/Member/Login");
        }
        int port = DistSSLConfirmYN == "Y" ? 443 : 80;
        bool redirectFlag = false;
        string siteType = ConfigurationManager.AppSettings["SiteType"].AsText("LocalHost");

        if (!Request.Url.Host.StartsWith("www") && siteType != "TestServer")
        {
            redirectFlag = true;
            host = "www." + Request.Url.Host;
        }
        if (redirectFlag && Request.Url.Scheme == Uri.UriSchemeHttp && !Request.Url.IsLoopback && PgConfirmYN == "N" && siteType != "TestServer")
        {
            UriBuilder secureUrl = new UriBuilder(Request.Url);
            secureUrl.Scheme = scheme;
            secureUrl.Host = host;
            secureUrl.Port = port;

            Response.Redirect(secureUrl.ToString(), false);
        }

    }
}
