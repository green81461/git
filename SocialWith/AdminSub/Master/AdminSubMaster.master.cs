using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.DistCss;
using Urian.Core;

public partial class AdminSub_Master_AdminSubMaster : System.Web.UI.MasterPage
{
    protected SocialWith.Biz.User.UserService UserService = new SocialWith.Biz.User.UserService();

    public string SvidRole = string.Empty;
    public string SvidUser = string.Empty;
    public string DongshinCheck = string.Empty;
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
    public string siteName = string.Empty;
    public string ssluse = "N";
    public string pge = "N";
    public string buyCompCode = "EMPTY";
    public string saleCompCode = "EMPTY";
    public string PriceCompCode = string.Empty;
    public string SearchTag = string.Empty;

    protected void Page_Init(object sender, EventArgs e)
    {

        SesstionCheck();
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        GetUser();
        GetSiteDistCss();
    }

    //로그인 여부에 따라 visible 조정
    protected void SesstionCheck()
    {
        if (Request.Cookies["AdminSub_LoginID"] == null)
        {
            HttpContext.Current.Response.Redirect("~/Member/Login.aspx");
            HttpContext.Current.Response.End();
        }
    }
    protected void GetUser()
    {

        var sesstionId = Request.Cookies["AdminSub_LoginID"].Value.AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_ID", sesstionId},  //로그인 session값 추가
        };
        var user = UserService.GetUser(paramList);
        if (user != null)
        {
            lblUser.Text = user.Name + "(" + user.Id + ")";
        }

        if (user.UserInfo != null)
        {
           // lblDept.Text = user.UserInfo.CompanyDept_Name;
           // lblCompany.Text = user.UserInfo.Company_Name;
        }
    }

    protected void btnLogout_Click(object sender, ImageClickEventArgs e)
    {
        CommonHelper.SetLogOut("SU");
    }
    protected void btnUserInfo_Click(object sender, ImageClickEventArgs e)
    {
        var userId = Request.Cookies["AdminSub_LoginID"].Value.AsText();
        Response.Redirect("~/AdminSub/Member/MemberEditCheck.aspx");
    }


    protected void GetSiteDistCss()
    {

        DistCssService distCssService = new DistCssService();

        string url = Request.Url.Host;
        //string url = "www.hwajinlocal.co.kr";

        if (url.Trim().StartsWith("www"))
        {
            url = url.Trim().Split('.')[1];
        }
        else
        {
            url = url.Trim().Split('.')[0];
        }
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_URL", url},
            { "nvar_P_SALECOMPCODE",saleCompCode},
            { "nvar_P_BUYCOMPCODE", buyCompCode},
             //{ "nvar_P_SALECOMPCODE","EMPTY"},
            //{ "nvar_P_BUYCOMPCODE", "EMPTY"},

        };

        var distInfo = distCssService.GetSiteDistCssInfo(paramList);
        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
        string cssPath = string.Empty;
        string metaTag = string.Empty;
        string favicon = string.Empty;
        string topBannerPath = string.Empty;
        string topLogoPath = string.Empty;
        string bottomLogoPath = string.Empty;
        string copyLogoPath = string.Empty;

        if (distInfo == null)
        {
            cssPath = Page.ResolveClientUrl(uploadFolder + "SiteManagement/Default/Main/SiteInfo.css");
            metaTag = "우리안에 오신걸 환영합니다.";
            Title = "우리안";
            //topBannerPath = Page.ResolveClientUrl(uploadFolder + "SiteManagement/Default/Main/top_banner.png");
            topLogoPath = Page.ResolveClientUrl(uploadFolder + "SiteManagement/Default/Main/main_logo.png");
            bottomLogoPath = Page.ResolveClientUrl(uploadFolder + "SiteManagement/Default/Main/main_bottom_logo.png");
            copyLogoPath = Page.ResolveClientUrl(uploadFolder + "SiteManagement/Default/Main/copyright.png");
            favicon = Page.ResolveClientUrl("");
            saleCompAddress = "서울시 금천구 벚꽃로 18길 15 ( 지번 : 금천구 독산동 1000-16)";
            companyName = "동신툴피아";
            distCompanyName = "우리안";
            lblSiteName.Text = distCompanyName + " 관리자";
            custTelNo = "1600-6395";
            enterDomainUrl = "www.socialwith.co.kr";
            siteName = "socialwith";
            SearchTag = "검색어를 입력해 주세요";

        }
        else
        {
            cssPath = string.IsNullOrWhiteSpace(distInfo.CssPath) ? Page.ResolveClientUrl(uploadFolder + "SiteManagement/Default/Main/SiteInfo.css") : distInfo.CssPath;
            metaTag = string.IsNullOrWhiteSpace(distInfo.MetaTag) ? "우리안에 오신걸 환영합니다." : distInfo.MetaTag;
            Title = string.IsNullOrWhiteSpace(distInfo.BrowserTag) ? "우리안" : distInfo.BrowserTag;
            favicon = miniLogo = string.IsNullOrWhiteSpace(distInfo.BrowseEmtcPath) ? Page.ResolveClientUrl(uploadFolder + "SiteManagement/Default/Main/mini_logo.png") : distInfo.BrowseEmtcPath;
            topBannerPath = string.IsNullOrWhiteSpace(distInfo.TopBannerPath) ? string.Empty : distInfo.TopBannerPath;
            topLogoPath = string.IsNullOrWhiteSpace(distInfo.TopLogoImagePath) ? Page.ResolveClientUrl(uploadFolder + "SiteManagement/Default/Main/main_logo.png") : distInfo.TopLogoImagePath;
            bottomLogoPath = string.IsNullOrWhiteSpace(distInfo.BottomLogoImagePath) ? Page.ResolveClientUrl(uploadFolder + "SiteManagement/Default/Main/main_bottom_logo.png") : distInfo.BottomLogoImagePath;
            copyLogoPath = string.IsNullOrWhiteSpace(distInfo.CopyRPath) ? Page.ResolveClientUrl(uploadFolder + "SiteManagement/Default/Main/copyright.png") : distInfo.CopyRPath;
            googleCode = distInfo.DistGoogleCode;
            custTelNo = string.IsNullOrWhiteSpace(distInfo.DistCustTelNo) ? "1600-6395" : distInfo.DistCustTelNo;
            daumCode = distInfo.CompanyDirection;
            DistCode = distInfo.DistCssCode;
            saleCompAddress = string.IsNullOrWhiteSpace(distInfo.CompanyDirectionCaption) ? "서울시 금천구 벚꽃로 18길 15 ( 지번 : 금천구 독산동 1000-16)" : distInfo.CompanyDirectionCaption;
            companyName = string.IsNullOrWhiteSpace(distInfo.CompanyName) ? "동신툴피아" : distInfo.CompanyName;
            distCompanyName = string.IsNullOrWhiteSpace(distInfo.DistCompanyName) ? "우리안" : distInfo.DistCompanyName;
            lblSiteName.Text = distCompanyName + " 관리자";
            enterDomainUrl = string.IsNullOrWhiteSpace(distInfo.EnterUrl) ? "www.socialwith.co.kr" : distInfo.EnterUrl;
            SearchTag = string.IsNullOrWhiteSpace(distInfo.SearchTag) ? "검색어를 입력해 주세요" : distInfo.SearchTag;

        }

        //hfDistCss.Value = JsonConvert.SerializeObject(list);
       // imgTopLogo.ImageUrl = uploadFolder + topLogoPath;
      //  imgBottomLogo.ImageUrl = uploadFolder + bottomLogoPath;
       // imgCopy.ImageUrl = uploadFolder + copyLogoPath;

        if (!string.IsNullOrWhiteSpace(topBannerPath))
        {
         //   imgTopBanner.Visible = true;
         //   imgTopBanner.ImageUrl = uploadFolder + topBannerPath;
        }
        else
        {
           // divTopmenu.Attributes.Add("style", "height: 0px;");
           // imgTopBanner.Visible = false;
        }
        //if (!string.IsNullOrWhiteSpace(favicon))
        //{
        //    imgBookmark.ImageUrl = uploadFolder + favicon;
        //}
        //else
        //{
        //    imgBookmark.Visible = false;
        //}
        //btnImgPowerSearch.ImageUrl = uploadFolder + "/SiteManagement/" + DistCode + "/main_search_btn.jpg";
      //  siteCss.Text = string.Format("<link rel=\"stylesheet\" type=\"text/css\" href=\"{0}\"></script>", Page.ResolveClientUrl(uploadFolder + cssPath));
      //  metaDescription.Text = metaOgDescription.Text = string.Format("<meta name=\"description\"  content=\"{0}\"></script>", metaTag);
      //  shortcut.Text = string.Format("<link rel=\"shortcut icon\" type=\"image/png\" href=\"{0}\"></script>", Page.ResolveClientUrl(uploadFolder + favicon));
    }

    protected void lbLogout_Click(object sender, EventArgs e)
    {
        CommonHelper.SetLogOut("SU");
    }
}
