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
        GetUser();
        GetSiteDistCss();

        defaultjs.Text = string.Format("<script type=\"text/javascript\" src=\"{0}\"></script>", "/UploadFile/SiteManagement/"+ DistCode + "/Main/default.js?dt=" + DateTime.Now.ToString("yyyyMMddhhmmss"));
        defaultCss.Text = string.Format("<link rel=\"stylesheet\" type=\"text/css\" href=\"{0}\"/>", "/UploadFile/SiteManagement/" + DistCode + "/Main/default.css?dt=" + DateTime.Now.ToString("yyyyMMddhhmmss"));

        //게스트계정 메뉴 접근 막기
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
        string siteType = ConfigurationManager.AppSettings["SiteType"].AsText();
        string distCode = ConfigurationManager.AppSettings["SettingDistCssCode"].AsText();
        string cssPath = string.Empty;
        string metaTag = string.Empty;
        string favicon = string.Empty;
        string topBannerPath = string.Empty;
        string topLogoPath = string.Empty;
        string bottomLogoPath = string.Empty;
        string copyLogoPath = string.Empty;

        if (siteType == "Localhost")
        {
            cssPath = "SiteInfo.css";
            metaTag = "소셜위드에 오신걸 환영합니다.";
            Title = "소셜위드";
            topLogoPath = "main_logo.png";
            bottomLogoPath = "main_bottom_logo.png";
            copyLogoPath = "copyright.png";
            topBannerPath = "top_banner.jpg";
            favicon = "";
            saleCompAddress = "서울 구로구 디지털로30길 28 404호";
            companyName = "소셜공감";
            distCompanyName = "소셜위드";
            custTelNo = "070-5226-1100";
            enterDomainUrl = "www.socialwith.co.kr";
            SiteName = "socialwith";
            SearchTag = "검색어를 입력해 주세요";
            DistCode = distCode;
        }
        else if (DistCssObject == null)
        {
            
            cssPath = Page.ResolveClientUrl(uploadFolder+"SiteManagement/Default/Main/SiteInfo.css");
            metaTag = "소셜위드에 오신걸 환영합니다.";
            Title = "소셜위드";
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
            PGEvaluation = DistCssObject.PgConfirmYN;
            cssPath = string.IsNullOrWhiteSpace(DistCssObject.CssPath) ? Page.ResolveClientUrl(uploadFolder+"SiteManagement/Default/Main/SiteInfo.css") : uploadFolder+ DistCssObject.CssPath;
            metaTag = string.IsNullOrWhiteSpace(DistCssObject.MetaTag) ? "소셜위드에 오신걸 환영합니다." : DistCssObject.MetaTag;
            Title = string.IsNullOrWhiteSpace(DistCssObject.BrowserTag) ? "소셜위드" : DistCssObject.BrowserTag;
            favicon = miniLogo = string.IsNullOrWhiteSpace(DistCssObject.BrowseEmtcPath) ? Page.ResolveClientUrl(uploadFolder+"SiteManagement/Default/Main/mini_logo.png") : uploadFolder+ DistCssObject.BrowseEmtcPath;
            topBannerPath = string.IsNullOrWhiteSpace(DistCssObject.TopBannerPath) ? string.Empty : uploadFolder + DistCssObject.TopBannerPath;
            topLogoPath = string.IsNullOrWhiteSpace(DistCssObject.TopLogoImagePath) ? Page.ResolveClientUrl(uploadFolder+"SiteManagement/Default/Main/main_logo.png") : uploadFolder+DistCssObject.TopLogoImagePath;
            bottomLogoPath = string.IsNullOrWhiteSpace(DistCssObject.BottomLogoImagePath) ? Page.ResolveClientUrl(uploadFolder+"SiteManagement/Default/Main/main_bottom_logo.png") : uploadFolder+DistCssObject.BottomLogoImagePath;
            copyLogoPath = string.IsNullOrWhiteSpace(DistCssObject.CopyRPath) ? Page.ResolveClientUrl(uploadFolder+"SiteManagement/Default/Main/copyright.png") : uploadFolder+DistCssObject.CopyRPath;
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

        imgTopLogo.ImageUrl = topLogoPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss");
        imgBottomLogo.ImageUrl = bottomLogoPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss");
        imgCopy.ImageUrl = copyLogoPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss");

        if (!string.IsNullOrWhiteSpace(topBannerPath))
        {
            imgTB.Visible = true;
            imgTB.ImageUrl = topBannerPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss");
            divTopmenu.Attributes.Add("display", "");
        }
        else
        {
            divTopmenu.Attributes.Add("style", "height: 0px;");
            imgTB.Visible = false;
        }
        
        siteCss.Text = string.Format("<link rel=\"stylesheet\" type=\"text/css\" href=\"{0}\"/>", Page.ResolveClientUrl(cssPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss")));
        metaDescription.Text = metaOgDescription.Text = string.Format("<meta name=\"description\"  content=\"{0}\"/>", metaTag);
        shortcut.Text = string.Format("<link rel=\"shortcut icon\" type=\"image/png\" href=\"{0}\"/>", Page.ResolveClientUrl(favicon + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss")));
        
    }
}