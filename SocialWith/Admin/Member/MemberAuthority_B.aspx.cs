using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;

public partial class Admin_Member_MemberAuthority_B : AdminPageBase
{
    public string uId = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
    }

    #region <<파라미터 Get>>
    protected void ParseRequestParameters()
    {
        uId = Request.QueryString["uId"].AsText();
    }
    #endregion
}