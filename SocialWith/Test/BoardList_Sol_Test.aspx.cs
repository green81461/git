using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using SocialWith.Data.Comm;

public partial class Test_BoardList_Sol_Test : PageBase
{
    protected int CurrentPage;
    protected SocialWith.Biz.Comm.CommService commService = new SocialWith.Biz.Comm.CommService();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        
        if (IsPostBack == false)
        {
            BoardBind();
        }
    }

    protected void ParseRequestParameters()
    {
     
    }

    protected void BoardBind(int page = 1)
    {
    }
}