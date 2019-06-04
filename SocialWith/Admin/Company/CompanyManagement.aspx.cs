using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_Company_CompanyManagement : AdminPageBase
{
    protected string Ucode;
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();

    }

    protected void ParseRequestParameters()
    {
        Ucode = Request.QueryString["ucode"].ToString();
    }
}