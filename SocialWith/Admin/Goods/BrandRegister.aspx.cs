using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Brand;
using Urian.Core;

public partial class Admin_Goods_BrandRegister : AdminPageBase
{
    BrandService brandService = new BrandService();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void ibCodeCreate_Click(object sender, EventArgs e)
    {
        var paramList = new Dictionary<string, object> {
            
        };
        string lastCode = brandService.GetLastBrandCode(paramList);
        string nextCode = StringValue.NextBrandCode(lastCode);
       
        hfBrandCode.Value = txtBrandCode.Text = nextCode;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        var paramList = new Dictionary<string, object>
        {
           {"nvar_P_BRANDCODE", hfBrandCode.Value.Trim() },
           {"nvar_P_BRANDNAME",txtBrandName.Text.Trim() },
           {"nvar_P_REMARK",txtRemark.Text.Trim() }
        };
        brandService.SaveBrand(paramList);
        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('저장되었습니다.');</script>");
    }


}