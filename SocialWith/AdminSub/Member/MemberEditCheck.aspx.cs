using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.User;
using Urian.Core;

public partial class AdminSub_Member_MemberEditCheck : AdminSubPageBase
{
    UserService userService = new UserService();
    string _userId = string.Empty;
    string qsUcode = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        if (IsPostBack == false)
        {
            GetUser();
        }
    }


    protected void ParseRequestParameters()
    {
        qsUcode = Request.QueryString["ucode"].AsText();
        // _userId = string.IsNullOrEmpty(Request.QueryString["userId"]) ? string.Empty : Request.QueryString["userId"].AsText();
        //   CurrentPage = string.IsNullOrEmpty(Request.QueryString["page"]) ? 1 : int.Parse(Request.QueryString["page"]);
    }

    protected void GetUser()
    {

        lblId.Text = UserId;
    }

   

    protected void btnConfirm_Click(object sender, EventArgs e)
    {
        //var siteName = ConfigurationManager.AppSettings["SiteName"].AsText();
        var siteName = Request.Cookies["SiteName"].Value.AsText("socialwith");
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_ID",  UserId},  //로그인 session값 추가
            //{ "nvar_P_ID", _userId},  //로그인 session값 추가
            { "nvar_P_PASSWORD", Crypt.MD5Encryption(txtPwd.Text.Trim()) },  //로그인 session값 추가
            {"nvar_P_URL", siteName } //사이트명
        };
        var user = userService.GetLoginUserInfo(paramList);
        if (user != null) //
        {
            if (!String.IsNullOrWhiteSpace(user.Gubun))
            {

                // Response.Redirect("MemberEdit_A.aspx");
                Response.Redirect("MemberEdit.aspx?ucode=" + qsUcode);

            }
        }
        else
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('비밀번호가 틀렸습니다.');</script>");
        }
    }
}