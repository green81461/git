using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;

public partial class Admin_Member_MemberLogInfo_B : AdminPageBase
{
    public string uId = string.Empty;
    public string ucode = string.Empty;
    protected SocialWith.Biz.User.UserService userService = new SocialWith.Biz.User.UserService();

    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();

        if (IsPostBack == false)
        {
            GetUserLogInfoBind();
        }
    }

    #region <<파라미터 Get>>
    protected void ParseRequestParameters()
    {
        uId = Request.QueryString["uId"].AsText();
        ucode = Request.QueryString["ucode"].AsText();
    }
    #endregion

    #region << 데이터바인드 >>
    protected void GetUserLogInfoBind()
    {
        var paramList = new Dictionary<string, object>() {
            {"nvar_P_ID", uId}
        };

        var info = userService.GetUserLogInfo_Admin(paramList);

        if (info != null)
        {
            lblLoginDate.Text = info.LoginDate.AsText();
            lblUpdateDate.Text = info.ModiDate.AsText();
            lblLoginCnt.Text = info.LoginCount.AsText();
        }

    }
    #endregion

    protected void Unnamed_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("MemberMain_B.aspx?ucode=" + ucode);
    }
}