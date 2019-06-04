using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.DistCss;
using Urian.Core;

public partial class Member_Login : LoginPageBase
{
    protected SocialWith.Biz.User.UserService service = new SocialWith.Biz.User.UserService();
    public string ConfirmFlag = string.Empty;
    public string returnUrl = string.Empty;
    public string ssluse = "N";
    public string pge = "N";
    public string CustTel = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        GetSiteDistCss();
        if (IsPostBack == false)
        {
            MemberBind();
            
        }
        ParseRequestParameters();
    }



    protected void MemberBind()
    {
        var saveIdFlag = Request.Cookies["SaveIdFlag"];
        var saveIdCookie = Request.Cookies["SaveId"];

        if ((saveIdFlag != null) && (saveIdFlag.Value == "Y") && saveIdCookie != null)
        {
            var saveId = Request.Cookies["SaveId"].Value;
            ckbSaveId.Checked = true;
            txtLoginId.Text = saveId;

        }
        else
        {
            ckbSaveId.Checked = false;
            txtLoginId.Text = "";
        }
    }
    protected void ParseRequestParameters()
    {
        string newSvidUser = Request.Form["openNewWindowSvidUser"];
        string newSvidId = Request.Form["openNewWindowId"];
        string newSvidGubun = Request.Form["openNewWindowGubun"];

        if (!string.IsNullOrWhiteSpace(newSvidUser.AsText()) && !string.IsNullOrWhiteSpace(newSvidUser.AsText()) && !string.IsNullOrWhiteSpace(newSvidUser.AsText())) //관리자 강제로그인용
        {
            SetLogin(newSvidUser.AsText(), newSvidId.AsText(), "", true, newSvidGubun.AsText(), "Y",  "Y");
        }
        
        //returnUrl = !string.IsNullOrWhiteSpace(Request.QueryString["returnUrl"].AsText()) ? Request.QueryString["returnUrl"].AsText() : "../";
    }
    
    protected void GetSiteDistCss()
    {
        
        string url = Request.Url.Host;
        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
        string cssPath = string.Empty;
        string favicon = string.Empty;
        string topImgPath = string.Empty;
        string bottomImgPath = string.Empty;
        string bgPath = string.Empty;
        string custTelNo = string.Empty;
        string siteName = string.Empty;
        string miniLogo = string.Empty;
        string loginLogoPath = string.Empty;
        string title = string.Empty;
        
        if (DistCssObject == null)
        {
            cssPath = Page.ResolveClientUrl("SiteManagement/Default/Main/SiteInfo.css");
            title = "소셜위드";
            topImgPath = Page.ResolveClientUrl("SiteManagement/Default/Login/login_topbanner.jpg");
            bottomImgPath = Page.ResolveClientUrl("SiteManagement/Default/Login/login_copyright.jpg");
            loginLogoPath = Page.ResolveClientUrl("SiteManagement/Default/Login/login_logo.jpg");
            bgPath = Page.ResolveClientUrl("SiteManagement/Default/Login/login_backgroundimg.jpg");
            CustTel = custTelNo = "070-5226-1100";
            siteName = "socialwith";
        }
        else
        {
            title = string.IsNullOrWhiteSpace(DistCssObject.BrowserTag) ? "소셜위드" : DistCssObject.BrowserTag;
            cssPath = string.IsNullOrWhiteSpace(DistCssObject.CssPath) ? Page.ResolveClientUrl("SiteManagement/Default/Main/SiteInfo.css") : DistCssObject.CssPath;
            favicon = miniLogo = string.IsNullOrWhiteSpace(DistCssObject.LoginBrowseEmtcPath) ? Page.ResolveClientUrl("") : DistCssObject.LoginBrowseEmtcPath;
            topImgPath = string.IsNullOrWhiteSpace(DistCssObject.LoginTopBannerPath) ? string.Empty : DistCssObject.LoginTopBannerPath;
            bottomImgPath = string.IsNullOrWhiteSpace(DistCssObject.LoginCopyrightPath) ? string.Empty : DistCssObject.LoginCopyrightPath;
            loginLogoPath = string.IsNullOrWhiteSpace(DistCssObject.LoginCompnayLogoPath) ? Page.ResolveClientUrl("SiteManagement/Default/Login/login_logo.jpg") : DistCssObject.LoginCompnayLogoPath;
            bgPath = string.IsNullOrWhiteSpace(DistCssObject.LoginBackgroundImgPath) ? string.Empty : DistCssObject.LoginBackgroundImgPath;
            CustTel = custTelNo = string.IsNullOrWhiteSpace(DistCssObject.DistCustTelNo) ? "070-5226-1100" : DistCssObject.DistCustTelNo;
            ssluse = string.IsNullOrWhiteSpace(DistCssObject.DistSSLConfirmYN) ? "N" : DistCssObject.DistSSLConfirmYN;
            pge = string.IsNullOrWhiteSpace(DistCssObject.PgConfirmYN) ? "N" : DistCssObject.PgConfirmYN;
        }


        imgLoginLogo.ImageUrl = uploadFolder + loginLogoPath;

        var litSiteCss = (Literal)this.Master.FindControl("litSiteCss");
        if (litSiteCss != null)
        {
            litSiteCss.Text = string.Format("<link rel=\"stylesheet\" type=\"text/css\" href=\"{0}\"></script>", Page.ResolveClientUrl(uploadFolder + cssPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss")));
        }
        var litShortcut = (Literal)this.Master.FindControl("litShortcut");
        if (litShortcut != null)
        {
            litShortcut.Text = string.Format("<link rel=\"shortcut icon\" type=\"image/png\" href=\"{0}\"></script>", Page.ResolveClientUrl(uploadFolder + favicon + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss")));
        }

        var litTitle = (Literal)this.Master.FindControl("litTitle");
        if (litTitle != null)
        {
            litTitle.Text = title;
        }

        if (!string.IsNullOrWhiteSpace(topImgPath))
        {
            imgHeader.ImageUrl = uploadFolder + topImgPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss");
        }
        else
        {
            imgHeader.Visible = false;
        }


        if (!string.IsNullOrWhiteSpace(bgPath))
        {
            imgBg.ImageUrl = uploadFolder + bgPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss");
        }
        else
        {
            imgBg.Visible = false;
        }


        if (!string.IsNullOrWhiteSpace(bottomImgPath))
        {
            imgCopyright.ImageUrl = uploadFolder + bottomImgPath + "?dt=" + DateTime.Now.ToString("yyyymmddhhmmss");
        }
        else
        {
            imgCopyright.Visible = false;
        }

    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        var loginId = txtLoginId.Text.Trim();
        var pwd = txtPwd.Text.Trim();
        
        var saveIdFlag = ckbSaveId.Checked == true ? "Y" : "N"; // 아이디 저장 구분값(Y:저장, N:저장안함)

        HttpCookie cookieSaveIdFlag = new HttpCookie("SaveIdFlag", saveIdFlag);
        HttpCookie cookieSaveId = new HttpCookie("SaveId", loginId);
        // 쿠키 30일간 저장
        cookieSaveIdFlag.Expires = DateTime.Now.AddDays(30);
        Response.Cookies.Add(cookieSaveIdFlag);
        Response.Cookies.Add(cookieSaveId);

        var paramList = new Dictionary<string, object> {
            {"nvar_P_ID", loginId },
            {"nvar_P_PASSWORD", Crypt.MD5Encryption(pwd) }, // 비밀번호 암호화
            {"nvar_P_URL", SiteName } //사이트명
        };

        var userInfo = service.GetLoginUserInfo(paramList);
        bool isSiteUser = true; //D-uri일때는 해당사이트의 사용자만 로그인할수 있게 체크

        if (userInfo != null)
        {
            if (!string.IsNullOrWhiteSpace(userInfo.UserInfo.EnterUrlDomain) && !string.IsNullOrWhiteSpace(SiteName))
            {
                if (userInfo.UserInfo.EnterUrlDomain.ToLower().IndexOf(SiteName.ToLower()) == -1) //도메인 확인
                {
                    isSiteUser = false;
                }
            }

            if (isSiteUser)
            {
                SetLogin(userInfo.Svid_User, loginId, pwd, isSiteUser, userInfo.Gubun.Substring(0, 2), userInfo.ConfirmFlag, "N");
            }
            else
            {
                lblLoginMsg.Text = "아이디 또는 비밀번호가 맞지 않습니다.";
            }
        }
        else
        {
            lblLoginMsg.Text = "아이디 또는 비밀번호가 맞지 않습니다.";
        }
        
    }


    protected void SetLogin(string svidUser, string loginId, string pwd,  bool isSiteUser, string gubun, string confirmFlag, string byAdminFlag) {

        // 사용자 정보가 있는 경우 (관리자 제외)
        if ((loginId != null) && isSiteUser && gubun != "AU")
        {
            if (confirmFlag == "Y")
            {
                var insertParamList = new Dictionary<string, object>
                {
                    {"nvar_P_SVIDUSER", svidUser },
                    {"nvar_P_GUBUN", "1" }, // 1.구매사 2.판매사 3.RMP 4.관리자, 5 그룹G
                    {"nvar_P_INFO",  "1" } // 1.로그인 2.장바구니 3.주문 4.결제
                };
                string redirectUrl = string.Empty;

                if (!string.IsNullOrWhiteSpace(gubun))
                {
                    if (gubun == "SU") //판매사 로그인
                    {
                        redirectUrl = "/AdminSub/Default.aspx";
                        CommonHelper.SetLogIn(svidUser, loginId, redirectUrl, gubun); // 로그인 세션 처리
                        if (byAdminFlag == "N")
                        {
                            insertParamList["nvar_P_GUBUN"] = "2";
                            service.InsertLoginHity(insertParamList);
                        }
                    }
                    else if (gubun == "BU") //구매사 로그인
                    {
                        redirectUrl = "/Default.aspx";
                        CommonHelper.SetLogIn(svidUser, loginId, redirectUrl, gubun); // 로그인 세션 처리
                        if (byAdminFlag == "N")
                        {
                            insertParamList["nvar_P_GUBUN"] = "1";
                            service.InsertLoginHity(insertParamList);
                        }
                    }
                    else
                    {
                        lblLoginMsg.Text = "아이디 또는 비밀번호가 맞지 않습니다.";
                    }
                }
                else
                {
                    lblLoginMsg.Text = "관리자가 회원승인중입니다";
                }
            }
            else
            {
                lblLoginMsg.Text = "관리자가 회원승인중입니다";
            }
        }
        else// 사용자 정보가 없는 경우
        {
            lblLoginMsg.Text = "아이디 또는 비밀번호가 맞지 않습니다.";
        }
    }
}


