using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AdminSub_BalanceAccounts_OrderBillIssue :AdminSubPageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DefaultDataBind();
        }
        
    }

    #region <<데이터바인드>>
    protected void DefaultDataBind()
    {
        //txtSearchEdate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        //txtSearchSdate.Text = DateTime.Now.AddDays(-7).ToString("yyyy-MM-dd");
        
    }
    #endregion
}