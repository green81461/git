using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;

public partial class Other_CompanyAbout : PageBase
{
    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
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