using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.User;
using Urian.Core;

public partial class Admin_Member_MemberMain_RMP : AdminPageBase
{
    protected string Ucode;
    UserService userService = new UserService();
    protected string totCount;

    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        if (IsPostBack == false)
        {
        }
    }
    protected void ParseRequestParameters()
    {
        Ucode = Request.QueryString["ucode"].ToString();
    }
}