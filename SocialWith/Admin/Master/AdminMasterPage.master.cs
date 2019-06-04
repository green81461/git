using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;

public partial class Admin_Master_AdminMasterPage : System.Web.UI.MasterPage
{
    protected SocialWith.Biz.User.UserService UserService = new SocialWith.Biz.User.UserService();

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
            HttpContext.Current.Response.End();
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
        }

        if (user.UserInfo != null)
        {
          //  lblDept.Text = user.UserInfo.CompanyDept_Name;
           // lblCompany.Text = user.UserInfo.Company_Name;
        }
    }
    
    protected void lbLogout_Click(object sender, EventArgs e)
    {
        CommonHelper.SetLogOut("AU");
    }
}
