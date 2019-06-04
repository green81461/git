using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;

public partial class AdminSub_Other_companyAbout : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
		ParseRequestParameters();
        if (IsPostBack == false)
        {
            
        }
    }

	protected void ParseRequestParameters()
    {
        var tabNum = Request.QueryString["tab"].AsText();
        if (tabNum.Equals(""))
        {
            tabNum = "1";
        }
        hfTabNum.Value = tabNum;
    }



    protected void pdfButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.ContentType = "application/octet-stream";
        Response.AppendHeader("Content-Disposition", "attachment; filename=URIAN_LOGO_AI.pdf");
        Response.TransmitFile(Server.MapPath("URIAN_LOGO_AI.pdf"));
        Response.End();
    }


    protected void imgButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.ContentType = "application/octet-stream";
        Response.AppendHeader("Content-Disposition", "attachment; filename=URIAN_LOGO_AI.jpg");
        Response.TransmitFile(Server.MapPath("URIAN_LOGO_AI.jpg"));
        Response.End();
    }
}