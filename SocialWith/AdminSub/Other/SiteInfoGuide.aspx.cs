﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AdminSub_Other_SiteInfoGuide : AdminSubPageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void Guidebutton_Click(object sender, ImageClickEventArgs e)
    {
        Response.ContentType = "application/octet-stream";
        Response.AppendHeader("Content-Disposition", "attachment; filename=SiteGuide.pdf");
        Response.TransmitFile(Server.MapPath("/images/SiteGuide/SiteGuide.pdf"));
        Response.End();
    }
}