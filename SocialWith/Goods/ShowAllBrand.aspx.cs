using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Brand;
using SocialWith.Biz.Category;
using Urian.Core;
using SocialWith.Data.Brand;

public partial class Goods_ShowAllBrand : PageBase
{
    CategoryService CategoryService = new CategoryService();
    BrandService BrandService = new BrandService();
    public string FinalCategoryCode = string.Empty;
    public string GoodsName = string.Empty;

    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;

    }
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        if (IsPostBack == false)
        {
            DefaultDataBind();
        }
    }

    #region <<파라미터 Get>>
    protected void ParseRequestParameters()
    {
        FinalCategoryCode = Request.QueryString["FinalCategoryCode"].AsText();
        GoodsName = Request.QueryString["GoodsName"].AsText();
    }

    #endregion

    protected void DefaultDataBind()
    {
         GetCategoryName();
    }

    protected void GetCategoryName()
    {
        var paramList = new Dictionary<string, object> {
            {"nvar_P_CATEGORYFINALCODE", FinalCategoryCode},

        };
        var categoryName = CategoryService.GetCategoryCurrentName(paramList);

        lbCategory.Text = categoryName;

        lblSearchKeyword.Text =  GoodsName;
    }
}