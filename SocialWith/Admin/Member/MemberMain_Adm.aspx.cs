using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.User;
using Urian.Core;

public partial class Admin_Member_MemberMain_Adm : AdminPageBase
{
    protected string Ucode;

    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
    }

    protected void ParseRequestParameters()
    {
        //  Svid = Request.QueryString["Svid"].ToString();
        Ucode = Request.QueryString["ucode"].ToString();
    }
}