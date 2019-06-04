using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;

public partial class Goods_GoodsCompareView : NonAuthenticationPageBase
{
    public string SvidUser = string.Empty;
    public string SvidRole = string.Empty;
    public string CompCode = string.Empty;
    public string SaleCompCode = string.Empty;
    public string BmroCheck = string.Empty;
    public string FreeCompanyYN = string.Empty;
    public string FreeCompanyVatYN = string.Empty;
    
    protected SocialWith.Biz.User.UserService service = new SocialWith.Biz.User.UserService();
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        if (!IsPostBack)
        {
            GetUser();
        }
    }

    #region <<파라미터 Get>>
    protected void ParseRequestParameters()
    {
        if (Request.Cookies["Svid_User"] != null)
        {
            SvidUser = Request.Cookies["Svid_User"].Value.AsText();
        }
    }
    protected void GetUser()
    {

        if (Request.Cookies["LoginID"] != null && Request.Cookies["LoginID"].Value.ToString().Length > 0)
        {

            var paramList = new Dictionary<string, object>() {
                    {"nvar_P_ID", Request.Cookies["LoginID"].Value}
                };
            var user = service.GetUser(paramList);
            if (user != null )
            {
                SvidRole = service.GetUser(paramList).Svid_Role;
                if (user.UserInfo  != null)
                {
                    CompCode = user.UserInfo.PriceCompCode;
                    SaleCompCode = user.UserInfo.SaleCompCode;
                    BmroCheck = user.UserInfo.BmroCheck;
                    FreeCompanyYN = user.UserInfo.FreeCompanyYN;
                    FreeCompanyVatYN = user.UserInfo.FreeCompanyVATYN;
                }
            }
        }

    }


    #endregion
}