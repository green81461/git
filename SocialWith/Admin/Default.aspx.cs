using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;
using NLog;

public partial class Admin_Default : AdminPageBase
{
    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;

    protected SocialWith.Biz.User.UserService UserService = new SocialWith.Biz.User.UserService();
    public string SvidUser = string.Empty;
    #endregion

    protected void Page_Init(object sender, EventArgs e)
    {
        SesstionCheck();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        GetUser();
    }

    //로그인 여부에 따라 visible 조정
    protected void SesstionCheck()
    {
        if (Request.Cookies["Admin_LoginID"] == null)
        {
            HttpContext.Current.Response.Redirect("~/Admin/Login.aspx");
        }
        
    }
    protected void GetUser()
    {

        var sesstionId = Request.Cookies["Admin_LoginID"].Value.AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_ID", sesstionId},  //로그인 session값 추가
        };
        var user = UserService.GetUser(paramList);
        if (user != null)
        {
            lblUser.Text = user.Name + "(" + user.Id + ")";
            SvidUser = user.Svid_User;

        }
    }


    protected void lbLogout_Click(object sender, EventArgs e)
    {
        CommonHelper.SetLogOut("AU");
    }
}