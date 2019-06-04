using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_Order_OrderBillListsch : AdminPageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DefaultValueSet();
    }


    protected void DefaultValueSet()
    {
        txtSearchEdate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        txtSearchSdate.Text = DateTime.Now.AddDays(-180).ToString("yyyy-MM-dd");

    }
}