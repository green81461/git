using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Pay;
using Urian.Core;

public partial class AdminSub_BalanceAccounts_BalanceSummary : AdminSubPageBase
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

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        this.txtSearchSdate.Text = Request[this.txtSearchSdate.UniqueID];
        this.txtSearchEdate.Text = Request[this.txtSearchEdate.UniqueID];

        sdate = txtSearchSdate.Text;
        edate = txtSearchEdate.Text;


        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", Svid_User }
            ,{"nvar_P_TODATEB",sdate}
            ,{"nvar_P_TODATEE",edate}

        };
        var list = PayService.GetJungSanList(paramList);

        if ((list != null) && (list.Count > 0))
        {
            BuySalePrice = list[0].BuySalePrice.AsText();
            GoodsBuyPrice = list[0].GoodsBuyPrice.AsText();
            SupplyCommPrice = list[0].SupplyCommPrice.AsText();
            AstotalPrice = list[0].AstotalPrice.AsText();
            PgPrice = list[0].PgPrice.AsText();
            BillCostPrice = list[0].BillCostPrice.AsText();
        }

        int iBuySalePrice = Convert.ToInt32(BuySalePrice);
        int iGoodsBuyPrice = Convert.ToInt32(GoodsBuyPrice);
        int iSupplyCommPrice = Convert.ToInt32(SupplyCommPrice);
        int iAstotalPrice = Convert.ToInt32(AstotalPrice);
        int iPgPrice = Convert.ToInt32(PgPrice);
        int iBillCostPrice = Convert.ToInt32(BillCostPrice);

        jungsan = iBuySalePrice + iGoodsBuyPrice + iSupplyCommPrice + iAstotalPrice + iBillCostPrice;
        if (iPgPrice != 0)
        {
            iPgPrice = jungsan / iPgPrice;
        }
        final = jungsan - iPgPrice;
    }

}