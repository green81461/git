using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.User;
using Urian.Core;

public partial class Member_MemberEditCheck : PageBase
{
    UserService userService = new UserService();
    string _userId = string.Empty;

    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string siteType = ConfigurationManager.AppSettings["SiteType"].AsText();
        string settingDistCssCode = ConfigurationManager.AppSettings["SettingDistCssCode"].AsText();//개발자용 배포코드
        string distCode = "DS00000002"; //기본 사이트배포코드값

        if (siteType == "Localhost")//Webconfig의 SiteType가 Localhost(개발자용)이면 Webconfig의 SettingDistCssCode의값을 갖고온다
        {
            distCode = settingDistCssCode;
        }
        else if (DistCssObject != null) //Webconfig의 SiteType가 Localhost(개발자용)가 아니고 DistCssObject가 널이 아니면 DistCssObject의 코드값을 갖고온다
        {
            distCode = DistCssObject.DistCssCode.AsText("DS00000002"); //사이트배포 데이터가 있으면 해당 코드를 갖고온다

        }
        string masterPageUrl = "~/UploadFile/SiteManagement/" + distCode + "/Main/Default.master"; //마스터페이지 분기처리(해당코드경로의 마스터페이지를 갖고옴)
        this.MasterPageFile = masterPageUrl;

    }

    protected void Page_Load(object sender, EventArgs e)
    {
        //ParseRequestParameters();
        if (IsPostBack == false)
        {
            GetUser();
        }
    }


    protected void ParseRequestParameters()
    {
       // _userId = string.IsNullOrEmpty(Request.QueryString["userId"]) ? string.Empty : Request.QueryString["userId"].AsText();
        //   CurrentPage = string.IsNullOrEmpty(Request.QueryString["page"]) ? 1 : int.Parse(Request.QueryString["page"]);
    }

    protected void GetUser() {

        lblId.Text = UserId;
    }

    
    protected void btnOk_Click(object sender, EventArgs e)
    {
        var siteName = SiteName.AsText("socialwith").ToLower();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_ID", UserId},  //로그인 session값 추가
            //{ "nvar_P_ID", _userId},  //로그인 session값 추가
            { "nvar_P_PASSWORD", Crypt.MD5Encryption(txtPwd.Text.Trim()) },  //로그인 session값 추가
            {"nvar_P_URL", siteName } //사이트명
        };
        var user = userService.GetLoginUserInfo(paramList);
        if (user != null) //
        {
            if (!String.IsNullOrWhiteSpace(user.Gubun))
            {
                var gubun = user.Gubun.Substring(0, 2);
                if (gubun == "SU")
                {
                    Response.Redirect("MemberEdit_A.aspx");

                }
                else
                {
                    Response.Redirect("MemberEdit.aspx");
                }
            }
            else
            {
                //
            }

        }
        else
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('비밀번호가 틀렸습니다.');</script>");
        }
    }
}