using NLog;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using SocialWith.Biz.DistCss;
using Urian.Core;

public partial class Master_Default : System.Web.UI.MasterPage
{
    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    protected SocialWith.Biz.User.UserService UserService = new SocialWith.Biz.User.UserService();
    public string SvidRole = string.Empty;
    public string SvidUser = string.Empty;
    public string BmroCheck = string.Empty;
    public string FreeCompanyYN = string.Empty;
    public string FreeCompanyVatYN = string.Empty;
    public string Title = string.Empty;
    public string DistCode = string.Empty;
    public string googleCode = string.Empty;
    public string custTelNo = string.Empty;
    public string daumCode = string.Empty;
    public string miniLogo = string.Empty;
    public string saleCompAddress = string.Empty;
    public string companyName = string.Empty;
    public string distCompanyName = string.Empty;
    public string enterDomainUrl = string.Empty;
    public string ssluse = "N";
    public string buyCompCode = "EMPTY";
    public string buyCompName = string.Empty;
    public string saleCompCode = "EMPTY";
    public string PriceCompCode = "EMPTY";
    public string UserId = string.Empty;
    public string SearchTag = string.Empty;
    public string Company_No = string.Empty;
    public string ftcUrl = "";
    public string FrontUrl = "http://www.ftc.go.kr/bizCommPop.do?wrkr_no=";
    public string BackUrl = "&apv_perm_no=";
    public string PGEvaluation = "N";
    public string SiteName = string.Empty;
    public string UseAdminRoleType = "N"; //사용자권한
    protected void Page_Init(object sender, EventArgs e)
    {
        if (Request.Cookies["Svid_User"] == null)
        {
            HttpContext.Current.Response.Redirect("~/Member/Login.aspx");
            HttpContext.Current.Response.End();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        GetUser();
        GetSiteDistCss();
        SiteRedirect();
        mastercss.Text = string.Format("<link rel=\"stylesheet\" type=\"text/css\" href=\"{0}\"/>", "/UploadFile/SiteManagement/" + DistCode + "/Main/master.css?dt=" + DateTime.Now.ToString("yyyyMMddhhmmss"));
        masterjs.Text = string.Format("<script type=\"text/javascript\" src=\"{0}\"></script>", "/UploadFile/SiteManagement/" + DistCode + "/Main/master.js?dt=" + DateTime.Now.ToString("yyyyMMddhhmmss"));

        if (UserId != "socialwith")
        {
            liStickyCart.Attributes.Add("style", "display:  ");
            liCategoryNewGood.Attributes.Add("style", "display:  ");
            liCategoryWish.Attributes.Add("style", "display:  ");
            ulRightInfo.Attributes.Add("style", "display: ");
            libottomCart.Attributes.Add("style", "display:  ");
        }

        if (UseAdminRoleType == "A")
        {
            liStatisticsMenu.Attributes.Add("style", "display:  ");
        }

        //탑배너 쿠키에 따른 display 분기처리
        if (Request.Cookies["divTopMenu"] != null)
        {
            if (Request.Cookies["divTopMenu"].Value != "N")
            {
                divTopmenu.Attributes.Add("style", "display:''");
            }
            else
            {
                divTopmenu.Attributes.Add("style", "display:none");
                divContent.Attributes.Add("style", "display:margin-top:201px");
            }
        }
    }

    
    

    protected void GetUser()
    {
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_ID", Request.Cookies["LoginID"].Value},  //로그인 session값 추가
        };
        var user = UserService.GetUser(paramList);
        if (user != null)
        {
            lblUser.Text = user.Name + " 님";

            SvidRole = user.Svid_Role;
            SvidUser = user.Svid_User;
            UserId = user.Id;
            if (user.UserInfo != null)
            {
                lblDeptName.Text = user.UserInfo.CompanyDept_Name;
                BmroCheck = user.UserInfo.BmroCheck;
                FreeCompanyYN = user.UserInfo.FreeCompanyYN.AsText("N");
                FreeCompanyVatYN = user.UserInfo.FreeCompanyVATYN.AsText("N");
                buyCompCode = !string.IsNullOrWhiteSpace(user.UserInfo.Company_Code) ? user.UserInfo.Company_Code : "EMPTY" ;
                buyCompName = !string.IsNullOrWhiteSpace(user.UserInfo.Company_Name) ? user.UserInfo.Company_Name : "EMPTY";
                saleCompCode = !string.IsNullOrWhiteSpace(user.UserInfo.SaleCompCode) ? user.UserInfo.SaleCompCode : "EMPTY";
                lblCartCnt.Text = user.UserInfo.CartCnt.AsInt(0).AsText();
                Company_No = user.UserInfo.SaleComapnyCode;
                Company_No = Company_No.Replace("-", "");
                PriceCompCode = user.UserInfo.PriceCompCode;
                ftcUrl = FrontUrl + Company_No + BackUrl;
                UseAdminRoleType = user.UserInfo.UseAdminRoleType;
            }
        }
    }

    protected void btnLogout_Click(object sender, ImageClickEventArgs e)
    {
        CommonHelper.SetLogOut("BU");
    }

    protected void btnUserInfo_Click(object sender, ImageClickEventArgs e)
    {
        var userId = Request.Cookies["LoginID"].Value.AsText();
        Response.Redirect(string.Format("~/Member/MemberEditCheck.aspx?userId={0}", userId));
    }

    protected void GetSiteDistCss()
    {

        DistCssService distCssService = new DistCssService();


        string url = Request.Url.Host;
        
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_URL", url},
            { "nvar_P_SALECOMPCODE",saleCompCode},
            { "nvar_P_BUYCOMPCODE", buyCompCode},

        };

        var distInfo = distCssService.GetSiteDistCssInfo(paramList);
        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
        string siteType = ConfigurationManager.AppSettings["SiteType"].AsText();
        string distCode = ConfigurationManager.AppSettings["SettingDistCssCode"].AsText();
        string cssPath = string.Empty;
        string metaTag = string.Empty;
        string topBannerPath = string.Empty;
        string favicon = string.Empty;
        string topLogoPath = string.Empty;
        string bottomLogoPath = string.Empty;
        string copyLogoPath = string.Empty;

        if (siteType == "Localhost") //개발용
        {
            DistCode = distCode;
            cssPath = uploadFolder +"/SiteManagement/" + DistCode + "/Main/SiteInfo.css";
            topBannerPath = uploadFolder + "SiteManagement/" + DistCode + "/Main/top_banner.jpg";
            metaTag = "소셜위드에 오신걸 환영합니다.";
            Title = "소셜위드";
            topLogoPath = uploadFolder + "SiteManagement/" + DistCode + "/Main/main_logo.png";
            bottomLogoPath = uploadFolder + "SiteManagement/" + DistCode + "/Main/main_bottom_logo.png";
            copyLogoPath = uploadFolder + "SiteManagement/" + DistCode + "/Main/copyright.png";
            favicon = "";
            saleCompAddress = "서울 구로구 디지털로30길 28 404호";
            companyName = "소셜공감";
            distCompanyName = "소셜위드";
            custTelNo = "070-5226-1100";
            enterDomainUrl = "www.socialwith.co.kr";
            SiteName = "socialwith";
            SearchTag = "검색어를 입력해 주세요";
           
        }
        else if (distInfo == null)
        {
            
            cssPath = Page.ResolveClientUrl(uploadFolder+"SiteManagement/Default/Main/SiteInfo.css");
            metaTag = "소셜공감에 오신걸 환영합니다.";
            Title = "소셜공감";
            topBannerPath = Page.ResolveClientUrl(uploadFolder+"SiteManagement/Default/Main/top_banner.png");
            topLogoPath = Page.ResolveClientUrl(uploadFolder+"SiteManagement/Default/Main/main_logo.png");
            bottomLogoPath = Page.ResolveClientUrl(uploadFolder+"SiteManagement/Default/Main/main_bottom_logo.png");
            copyLogoPath = Page.ResolveClientUrl(uploadFolder+"SiteManagement/Default/Main/copyright.png");
            favicon = Page.ResolveClientUrl("");
            saleCompAddress = "서울 구로구 디지털로30길 28 404호";
            companyName = "소셜공감";
            distCompanyName = "소셜위드";
            custTelNo = "070-5226-1100";
            enterDomainUrl = "www.socialwith.co.kr";
            SiteName = "socialwith";
            SearchTag = "검색어를 입력해 주세요"; 
        }
        else
        {
            PGEvaluation = distInfo.PgConfirmYN;
            cssPath = string.IsNullOrWhiteSpace(distInfo.CssPath) ? Page.ResolveClientUrl(uploadFolder+"SiteManagement/Default/Main/SiteInfo.css") : uploadFolder+distInfo.CssPath;
            metaTag = string.IsNullOrWhiteSpace(distInfo.MetaTag) ? "소셜공감에 오신걸 환영합니다." : distInfo.MetaTag;
            Title = string.IsNullOrWhiteSpace(distInfo.BrowserTag) ? "소셜공감" : distInfo.BrowserTag;
            favicon = miniLogo = string.IsNullOrWhiteSpace(distInfo.BrowseEmtcPath) ? Page.ResolveClientUrl(uploadFolder+"SiteManagement/Default/Main/mini_logo.png") : uploadFolder+distInfo.BrowseEmtcPath;
            topBannerPath = string.IsNullOrWhiteSpace(distInfo.TopBannerPath) ? string.Empty : uploadFolder+distInfo.TopBannerPath;
            topLogoPath = string.IsNullOrWhiteSpace(distInfo.TopLogoImagePath) ? Page.ResolveClientUrl(uploadFolder+"SiteManagement/Default/Main/main_logo.png") : uploadFolder+distInfo.TopLogoImagePath;
            bottomLogoPath = string.IsNullOrWhiteSpace(distInfo.BottomLogoImagePath) ? Page.ResolveClientUrl(uploadFolder+"SiteManagement/Default/Main/main_bottom_logo.png") : uploadFolder+distInfo.BottomLogoImagePath;
            copyLogoPath = string.IsNullOrWhiteSpace(distInfo.CopyRPath) ? Page.ResolveClientUrl(uploadFolder+"SiteManagement/Default/Main/copyright.png") : uploadFolder+distInfo.CopyRPath;
            googleCode = distInfo.DistGoogleCode;
            custTelNo = string.IsNullOrWhiteSpace(distInfo.DistCustTelNo) ? "070-5226-1100" : distInfo.DistCustTelNo;
            daumCode = distInfo.CompanyDirection;
            DistCode = distInfo.DistCssCode;
            ssluse = distInfo.DistSSLConfirmYN;
            saleCompAddress = string.IsNullOrWhiteSpace(distInfo.CompanyDirectionCaption) ? "서울 구로구 디지털로30길 28 404호" : distInfo.CompanyDirectionCaption;
            companyName = string.IsNullOrWhiteSpace(distInfo.CompanyName) ? "소셜공감" : distInfo.CompanyName;
            distCompanyName = string.IsNullOrWhiteSpace(distInfo.DistCompanyName) ? "소셜공감" : distInfo.DistCompanyName;
            enterDomainUrl = string.IsNullOrWhiteSpace(distInfo.EnterUrl) ? "www.socialwith.co.kr" : distInfo.EnterUrl;
            SearchTag = string.IsNullOrWhiteSpace(distInfo.SearchTag) ? "검색어를 입력해 주세요" : distInfo.SearchTag;
        }

        imgTopLogo.ImageUrl = topLogoPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss");
        imgBottomLogo.ImageUrl = bottomLogoPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss");
        imgCopy.ImageUrl = copyLogoPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss");
        if (!string.IsNullOrWhiteSpace(topBannerPath))
        {
            imgTB.Visible = true;
            imgTB.ImageUrl = topBannerPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss");
            divContent.Attributes.Add("style", "margin-top:260px");
        }
        else
        {
            divTopmenu.Attributes.Add("style", "height: 0px;");
            divContent.Attributes.Add("style", "margin-top:201px");
            imgTB.Visible = false;
        }
        
        siteCss.Text = string.Format("<link rel=\"stylesheet\" type=\"text/css\" href=\"{0}\"/>", Page.ResolveClientUrl(cssPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss")));
        metaDescription.Text = metaOgDescription.Text = string.Format("<meta name=\"description\"  content=\"{0}\"/>", metaTag);
        shortcut.Text = string.Format("<link rel=\"shortcut icon\" type=\"image/png\" href=\"{0}\"/>", Page.ResolveClientUrl(favicon + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss")));
    }

    protected void SiteRedirect()
    {
        var sslFlag = ssluse.AsText("N");

        string scheme = sslFlag == "Y" ? "https" : "http";
        string host = Request.Url.Host;
        int port = sslFlag == "Y" ? 443 : 80;
        bool redirectFlag = false;
        string siteType = ConfigurationManager.AppSettings["SiteType"].AsText("LocalHost");

        if (!Request.Url.Host.StartsWith("www") && siteType != "TestServer")
        {
            redirectFlag = true;
            host = "www." + Request.Url.Host;
        }
        if (redirectFlag && Request.Url.Scheme == Uri.UriSchemeHttp && !Request.Url.IsLoopback && PGEvaluation== "N")
        {
            UriBuilder secureUrl = new UriBuilder(Request.Url);
            secureUrl.Scheme = scheme;
            secureUrl.Host = host;
            secureUrl.Port = port;

            Response.Redirect(secureUrl.ToString(), false);
        }

    }
    
}
