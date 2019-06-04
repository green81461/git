using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Pay;
using Urian.Core;


public partial class Admin_BalanceAccounts_BalanceSummary : AdminPageBase
{
    PayService PayService = new PayService();

    protected String BuySalePrice;
    protected String GoodsBuyPrice;
    protected String SupplyCommPrice;
    protected String AstotalPrice;
    protected String PgPrice;
    protected String BillCostPrice;
    protected int final;
    protected int jungsan;
    protected String sdate;
    protected String edate;


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            DefaultDataBind();
        }
    }

    protected void DefaultDataBind()
    {
        txtSearchSdate.Text = DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd");
        txtSearchEdate.Text = DateTime.Now.ToString("yyyy-MM-dd");
    }

    #region <<엑셀저장 마우스 이벤트>>
    protected void btnExcelExport_Click(object sender, EventArgs e)
    {

    }
    #endregion


}