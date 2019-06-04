using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Goods;

public partial class Admin_Goods_RecommListSearch : AdminPageBase
{
    GoodsRecommService RecommService = new GoodsRecommService();
    protected string Ucode = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        txtSearchSdate.Text = DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd");
        txtSearchEdate.Text = DateTime.Now.ToString("yyyy-MM-dd");
    }

    protected void ParseRequestParameters()
    {
        Ucode = Request.QueryString["ucode"].ToString();
    }

    protected void click_Delete(object sender, EventArgs e)
    {

        var hdCode = Request[this.hdCode.UniqueID];
        var hdDelFlag = Request[this.hdDelFlag.UniqueID];
        var paramList = new Dictionary<string, object>
        {
             {"nvar_P_GOODSRECOMMCODE", hdCode},
            {"nvar_P_BUYRECOMMDELFLAG", hdDelFlag},


        };
        RecommService.GoodsRecommList_Del(paramList);
        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('삭제되었습니다.');</script>");
        Response.Redirect(string.Format("RecommListSearch.aspx?Ucode=" + Ucode)); //메인으로 가기.

    }
}
