using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Category;
using SocialWith.Biz.Goods;
using Urian.Core;

public partial class Goods_GoodsDetailSearch : System.Web.UI.Page
{
    CategoryService CategoryService = new CategoryService();
    GoodsService GoodsService = new GoodsService();
    

    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        if (IsPostBack == false)
        {
            DefaultDataBind();
        }
    }

    protected void DefaultDataBind()
    {
        GetCategoryList(); 
    }


    protected void GetCategoryList()
    {
        var paramList = new Dictionary<string, object> {};

        var list = CategoryService.GetCategoryParentList(paramList);

        if ((list != null) && (list.Count > 0))
        {
            foreach (var item in list)
            {
                if (item.CategoryNo != "0")
                {
                    ddlCategoryCode.Items.Add(new ListItem(item.CategoryFinalName, item.CategoryFinalCode));
                   
                }
            }
        }
    }

    protected void ParseRequestParameters()
    {
        //ModelName = Request.QueryString["ModelName"].AsText();
        //GoodsCode = Request.QueryString["GoodsCode"].AsText();
        //CategoryCode = Request.QueryString["CategoryCode"].AsText();
        //BrandName = Request.QueryString["BrandName"].AsText();
        //GoodsName = Request.QueryString["GoodsName"].AsText();
        //Type = Request.QueryString["Type"].AsText();
        
    }
    
    protected string GetCode(string goodsCode) {
        string code = string.Empty;
        var paramList = new Dictionary<string, object> {
            {"nvar_P_GOODSCODE", goodsCode}
        };
        var list = GoodsService.GetCategoryCodeByGoodsCode(paramList);
        if ((list != null) && (list.Count > 0))
        {
            foreach (var item in list)
            {
                code = item.GoodsFinalCategoryCode +"/"+item.BrandCode;
            }
        }

        return code;
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string url = string.Empty;
        string codes = string.Empty;
        string categoryCode = string.Empty;
        string brandCode = string.Empty;
        string type = string.Empty;
        if (!string.IsNullOrWhiteSpace(txtgoodsCode.Text.Trim()))
        {
            url = "GoodsDetail.aspx";
            codes = GetCode(txtgoodsCode.Text.Trim());
            if (!string.IsNullOrWhiteSpace(codes))
            {
                categoryCode = codes.Split('/')[0];
                brandCode = codes.Split('/')[1];
            }
            type = "ds";
        }
        else
        {
            url = "GoodsList.aspx";
            categoryCode = ddlCategoryCode.SelectedValue.Trim();
            type = "ds";
        }
        Response.Redirect(string.Format("{0}?GoodsModel={1}&GoodsCode={2}&CategoryCode={3}&BrandName={4}&BrandCode={5}&GoodsName={6}&Type={7}", url, txtmodelName.Text.Trim(), txtgoodsCode.Text.Trim(), categoryCode, txtbrandName.Text.Trim(), brandCode, txtgoodsName.Text.Trim(), type));
    }
}