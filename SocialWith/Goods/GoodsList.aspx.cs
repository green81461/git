using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Category;
using SocialWith.Biz.Goods;
using SocialWith.Biz.User;
using Urian.Core;

public partial class Goods_GoodsList : PageBase
{
    CategoryService CategoryService = new CategoryService();
    GoodsService GoodsService = new GoodsService();
    public string FinalCategoryCode = string.Empty;
    public string SvidUser = string.Empty;
    public string SvidRole = string.Empty;
    public string PriceCompCode = string.Empty;
    public string CompCode = string.Empty;
    public string SaleCompCode = string.Empty;
    public string BmroCheck = string.Empty;
    public string FreeCompanyYN = string.Empty;
    public string FreeCompanyVATYN = string.Empty;
    public string Gubun = string.Empty;
    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        goodsCss.Text = string.Format("<link rel=\"stylesheet\" type=\"text/css\" href=\"{0}\"/>", "../Content/Goods/goods.css?dt=" + DateTime.Now.ToString("yyyyMMddhhmmss"));
        goodsListjs.Text = string.Format("<script type=\"text/javascript\" src=\"{0}\"></script>", "../Scripts/goodslist.js?dt=" + DateTime.Now.ToString("yyyyMMddhhmmss"));
        if (IsPostBack == false)
        {

            DefaultDataBind();
            SaveCategorySearchLog();
        }
    }

    #region <<파라미터 Get>>
    protected void ParseRequestParameters()
    {
        FinalCategoryCode = Request.QueryString["CategoryCode"].AsText();
        if (Request.Cookies["Svid_User"] != null)
        {
            SvidUser = Request.Cookies["Svid_User"].Value.AsText();
        }
    }

    #endregion
    protected void SaveCategorySearchLog()
    {

        string svidUser = string.Empty;
        GoodsService GoodsService = new GoodsService();
        if (string.IsNullOrWhiteSpace(SvidUser))
        {
            svidUser = GetGoodsSearchLogSvidSeq();
        }
        else
        {
            svidUser = SvidUser;
        }

        var paramList = new Dictionary<string, object> {
            {"nvar_P_CATEGORYCODE", FinalCategoryCode},
            {"nvar_P_GUBUN", Gubun},
            {"nvar_P_SVID_USER", svidUser}
        };


        GoodsService.SaveCategorySearchLog(paramList);
    }



    protected void DefaultDataBind()
    {
        UserService service = new UserService();
        if (Request.Cookies["LoginID"] != null)
        {
            var paramList = new Dictionary<string, object>() {
                    {"nvar_P_ID", Request.Cookies["LoginID"].Value.AsText()}
                };

            var user = service.GetUser(paramList);
            if (user != null && user.UserInfo != null)
            {
                SvidRole = user.Svid_Role;
                CompCode = user.UserInfo.Company_Code;
                PriceCompCode = user.UserInfo.PriceCompCode;
                BmroCheck = user.UserInfo.BmroCheck;
                SaleCompCode = user.UserInfo.SaleCompCode;
                FreeCompanyYN = user.UserInfo.FreeCompanyYN;
                FreeCompanyVATYN = user.UserInfo.FreeCompanyVATYN;
                Gubun = user.Gubun;


            }

            //ucLeftMenu.CompCode = user.UserInfo.Company_Code;
            //ucLeftMenu.SaleCompCode = user.UserInfo.SaleCompCode;
            //ucLeftMenu.BdongshinCheck = user.UserInfo.BdongshinCheck;
        }
    }

    protected string GetGoodsSearchLogSvidSeq()
    {
        GoodsService GoodsService = new GoodsService();
        string query = "select GOODSSEARCHLOG_SEQ.NEXTVAL from dual";
        var svidSeq = GoodsService.GetGoodsSearchLogSvidUserSeq(query);

        string returnData = string.Empty;

        string nowDate = DateTime.Now.ToString("yyMMdd");
        returnData = nowDate + "S" + svidSeq.ToString("0000000");

        return returnData;
    }
}