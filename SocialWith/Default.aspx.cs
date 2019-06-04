using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using SocialWith.Biz.DistCss;
using Urian.Core;
using System.Web.Routing;

public partial class _Default : PageBase
{
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
    public string saleCompCode = "EMPTY";
    public string PriceCompCode = string.Empty;
    public string SearchTag = string.Empty;
    public string Company_No = string.Empty;
    public string ftcUrl = "";
    public string FrontUrl = "http://www.ftc.go.kr/bizCommPop.do?wrkr_no=";
    public string BackUrl = "&apv_perm_no=";
    public string PGEvaluation = "N";
    
    protected void Page_Load(object sender, EventArgs e)
    {

        mainjs.Text = string.Format("<script type=\"text/javascript\" src=\"{0}\"></script>", "../Scripts/main.js?dt=" + DateTime.Now.ToString("yyyyMMddhhmmss"));
        mainCss.Text = string.Format("<link rel=\"stylesheet\" type=\"text/css\" href=\"{0}\"/>", "../Content/main.css?dt="+DateTime.Now.ToString("yyyyMMddhhmmss"));
        commonCss.Text = string.Format("<link rel=\"stylesheet\" type=\"text/css\" href=\"{0}\"/>", "../Content/common.css?dt=" + DateTime.Now.ToString("yyyyMMddhhmmss"));
        goodsCss.Text = string.Format("<link rel=\"stylesheet\" type=\"text/css\" href=\"{0}\"/>", "../Content/Goods/goods.css?dt=" + DateTime.Now.ToString("yyyyMMddhhmmss"));
        GetUser();
        GetSiteDistCss();
        SiteRedirect();

        if (UserId != "socialwith")
        {
            liStickyCart.Attributes.Add("style", "display:  ");
            liCategoryNewGood.Attributes.Add("style", "display:  ");
            liCategoryWish.Attributes.Add("style", "display:  ");
            ulRightInfo.Attributes.Add("style", "display: ");
            libottomCart.Attributes.Add("style", "display:  ");
        }

        //사용자 관리자 권한이 ADMIN이면 관리자 통계화면 메뉴 보여지게..
        if (UserInfoObject.UserInfo.UseAdminRoleType == "A")
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
            }
        }
    }

    protected void GetUser()
    {

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_ID", UserId},  //로그인 session값 추가
        };

        var user = UserService.GetUser(paramList);
        if (user != null)
        {
            lblUser.Text = user.Name + " 님";
            SvidRole = user.Svid_Role;
            SvidUser = user.Svid_User;

            if (user.UserInfo != null)
            {
                lblDeptName.Text = user.UserInfo.CompanyDept_Name;
                BmroCheck = user.UserInfo.BmroCheck;
                FreeCompanyYN = user.UserInfo.FreeCompanyYN.AsText("N");
                FreeCompanyVatYN = user.UserInfo.FreeCompanyVATYN.AsText("N");
                buyCompCode = !string.IsNullOrWhiteSpace(user.UserInfo.Company_Code) ? user.UserInfo.Company_Code : "EMPTY";
                saleCompCode = !string.IsNullOrWhiteSpace(user.UserInfo.SaleCompCode) ? user.UserInfo.SaleCompCode : "EMPTY";
                PriceCompCode = !string.IsNullOrWhiteSpace(user.UserInfo.PriceCompCode) ? user.UserInfo.PriceCompCode : "EMPTY";
                lblCartCnt.Text = user.UserInfo.CartCnt.AsInt(0).AsText();
                Company_No = user.UserInfo.SaleComapnyCode;
                Company_No = Company_No.Replace("-", "");
                ftcUrl = FrontUrl + Company_No + BackUrl;
            }
        }

    }
    
    protected void GetSiteDistCss()
    {
        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
        string cssPath = string.Empty;
        string metaTag = string.Empty;
        string favicon = string.Empty;
        string topBannerPath = string.Empty;
        string topLogoPath = string.Empty;
        string bottomLogoPath = string.Empty;
        string copyLogoPath = string.Empty;
        if (DistCssObject == null)
        {
            
            cssPath = Page.ResolveClientUrl("SiteManagement/Default/Main/SiteInfo.css");
            metaTag = "소셜위드에 오신걸 환영합니다.";
            Title = "소셜위드";
            topLogoPath = Page.ResolveClientUrl("SiteManagement/Default/Main/main_logo.png");
            bottomLogoPath = Page.ResolveClientUrl("SiteManagement/Default/Main/main_bottom_logo.png");
            copyLogoPath = Page.ResolveClientUrl("SiteManagement/Default/Main/copyright.png");
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
            PGEvaluation = DistCssObject.PgConfirmYN;
            cssPath = string.IsNullOrWhiteSpace(DistCssObject.CssPath) ? Page.ResolveClientUrl("SiteManagement/Default/Main/SiteInfo.css") : DistCssObject.CssPath;
            metaTag = string.IsNullOrWhiteSpace(DistCssObject.MetaTag) ? "소셜위드에 오신걸 환영합니다." : DistCssObject.MetaTag;
            Title = string.IsNullOrWhiteSpace(DistCssObject.BrowserTag) ? "소셜위드" : DistCssObject.BrowserTag;
            favicon = miniLogo = string.IsNullOrWhiteSpace(DistCssObject.BrowseEmtcPath) ? Page.ResolveClientUrl("SiteManagement/Default/Main/mini_logo.png") : DistCssObject.BrowseEmtcPath;
            topBannerPath = string.IsNullOrWhiteSpace(DistCssObject.TopBannerPath) ? string.Empty : DistCssObject.TopBannerPath;
            topLogoPath = string.IsNullOrWhiteSpace(DistCssObject.TopLogoImagePath) ? Page.ResolveClientUrl("SiteManagement/Default/Main/main_logo.png") : DistCssObject.TopLogoImagePath;
            bottomLogoPath = string.IsNullOrWhiteSpace(DistCssObject.BottomLogoImagePath) ? Page.ResolveClientUrl("SiteManagement/Default/Main/main_bottom_logo.png") : DistCssObject.BottomLogoImagePath;
            copyLogoPath = string.IsNullOrWhiteSpace(DistCssObject.CopyRPath) ? Page.ResolveClientUrl("SiteManagement/Default/Main/copyright.png") : DistCssObject.CopyRPath;
            googleCode = DistCssObject.DistGoogleCode;
            custTelNo = string.IsNullOrWhiteSpace(DistCssObject.DistCustTelNo) ? "070-5226-1100" : DistCssObject.DistCustTelNo;
            daumCode = DistCssObject.CompanyDirection;
            DistCode = DistCssObject.DistCssCode;
            
            saleCompAddress = string.IsNullOrWhiteSpace(DistCssObject.CompanyDirectionCaption) ? "서울 구로구 디지털로30길 28 404호" : DistCssObject.CompanyDirectionCaption;
            companyName = string.IsNullOrWhiteSpace(DistCssObject.CompanyName) ? "소셜위드" : DistCssObject.CompanyName;
            distCompanyName = string.IsNullOrWhiteSpace(DistCssObject.DistCompanyName) ? "소셜위드" : DistCssObject.DistCompanyName;
            enterDomainUrl = string.IsNullOrWhiteSpace(DistCssObject.EnterUrl) ? "www.socialwith.co.kr" : DistCssObject.EnterUrl;
            SearchTag = string.IsNullOrWhiteSpace(DistCssObject.SearchTag) ? "검색어를 입력해 주세요" : DistCssObject.SearchTag;

        }

        imgTopLogo.ImageUrl = uploadFolder + topLogoPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss");
        imgBottomLogo.ImageUrl = uploadFolder + bottomLogoPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss");
        imgCopy.ImageUrl = uploadFolder + copyLogoPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss");

        if (!string.IsNullOrWhiteSpace(topBannerPath))
        {
            imgTB.Visible = true;
            imgTB.ImageUrl = uploadFolder + topBannerPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss");
            divTopmenu.Attributes.Add("display", "");
        }
        else
        {
            divTopmenu.Attributes.Add("style", "height: 0px;");
            imgTB.Visible = false;
        }
        
        siteCss.Text = string.Format("<link rel=\"stylesheet\" type=\"text/css\" href=\"{0}\"/>", Page.ResolveClientUrl(uploadFolder + cssPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss")));
        metaDescription.Text = metaOgDescription.Text = string.Format("<meta name=\"description\"  content=\"{0}\"/>", metaTag);
        shortcut.Text = string.Format("<link rel=\"shortcut icon\" type=\"image/png\" href=\"{0}\"/>", Page.ResolveClientUrl(uploadFolder + favicon + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss")));


        //디폴트페이지

        
    }

    protected void SiteRedirect()
    {
        var sslFlag = ssluse.AsText("N");

        string scheme = sslFlag == "Y" ? "https" : "http";
        string host = Request.Url.Host;
        if (SiteName == "socialex") //무한상사 구매사 도로공사용 도메인... 이걸로 접속하면 무한상사 도메인으로 페이지 이동
        {
            Response.Redirect(scheme + "://www.muhancoop.com");
        }
        int port = sslFlag == "Y" ? 443 : 80;
        bool redirectFlag = false;
        string siteType = ConfigurationManager.AppSettings["SiteType"].AsText("LocalHost");

        if (!Request.Url.Host.StartsWith("www") && siteType != "TestServer")
        {
            redirectFlag = true;
            host = "www." + Request.Url.Host;
        }
        if (redirectFlag && Request.Url.Scheme == Uri.UriSchemeHttp && !Request.Url.IsLoopback && PGEvaluation == "N")
        {
            UriBuilder secureUrl = new UriBuilder(Request.Url);
            secureUrl.Scheme = scheme;
            secureUrl.Host = host;
            secureUrl.Port = port;

            Response.Redirect(secureUrl.ToString(), false);
        }
        string settingDistCssCode = ConfigurationManager.AppSettings["SettingDistCssCode"].AsText();//개발자용 배포코드
        string distCode = "DS00000002"; //기본 사이트배포코드값

        if (siteType == "Localhost")//Webconfig의 SiteType가 Localhost(개발자용)이면 Webconfig의 SettingDistCssCode의값을 갖고온다
        {
            distCode = settingDistCssCode;
        }
        else if (DistCssObject != null) //Webconfig의 SiteType가 Localhost(개발자용)가 아니고 DistCssObject가 널이 아니면 DistCssObject의 코드값을 갖고온다
        {
            distCode = DistCode.AsText("DS00000002"); //사이트배포 데이터가 있으면 해당 코드를 갖고온다
        }
        string redirectUrl = "~/UploadFile/SiteManagement/" + distCode + "/Main/Default.aspx";
        Server.Transfer(redirectUrl); //해당경로의 디폴트 페이지로 서버 트랜스퍼

    }
}