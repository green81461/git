using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Goods;

public partial class Test_CreateGoodsCode : System.Web.UI.Page
{
    GoodsService goodsService = new GoodsService();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btnGenerateCode_Click(object sender, EventArgs e)
    {
        var param = new Dictionary<string, object> { };
        var curCode = goodsService.GetLastGoodsCode(param);

        //string gCode = StringValue.GetNextCodeOneAndNum(curCode, 6);
        //txtGoodsCode.Text = gCode.Trim();
    }

    protected void btnGenerateGroupCode_Click(object sender, EventArgs e)
    {
        var param = new Dictionary<string, object> { };
        var curCode = goodsService.GetLastGroupCode(param);

        //string gCode = StringValue.GetNextCodeOneAndNum(curCode, 5);
        //txtGroupCode.Text = gCode.Trim();
    }
}