using OfficeOpenXml;
using OfficeOpenXml.Style;
using Oracle.ManagedDataAccess.Client;
//using Oracle.DataAccess.Client;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Excel;
using SocialWith.Biz.Goods;
using Urian.Core;

public partial class Admin_Goods_GoodsGroupCodeRank : AdminPageBase
{
    protected string GoodsCode;
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();

    }

    protected void ParseRequestParameters()
    {
        GoodsCode = Request.QueryString["GoodsCode"].AsText();
    }

    

    

    

    
} 