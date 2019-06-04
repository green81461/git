using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Category;
using SocialWith.Biz.Goods;
using SocialWith.Biz.User;
using Urian.Core;

public partial class Goods_GoodsDetail : PageBase
{
    protected UserService UserService = new UserService();
    
    CategoryService CategoryService = new CategoryService();
    GoodsService GoodsService = new GoodsService();
    public string FinalCategoryCode = string.Empty;
    public string GoodsGroupCode = string.Empty;
    public string GoodsCode = string.Empty;
    public string SvidUser = string.Empty;
    public string SvidRole = string.Empty;
    public string Gubun = string.Empty;
    public string PriceCompCode = string.Empty;
    public string CompCode = string.Empty;
    public string SaleCompCode = string.Empty;
    public string BmroCheck = string.Empty;
    public string FreeCompanyYN = string.Empty;
    public string FreeCompanyVatYN = string.Empty;
    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        goodsCss.Text = string.Format("<link rel=\"stylesheet\" type=\"text/css\" href=\"{0}\"/>", "../Content/Goods/goods.css?dt=" + DateTime.Now.ToString("yyyyMMddhhmmss"));
        goodsDetailjs.Text = string.Format("<script type=\"text/javascript\" src=\"{0}\"></script>", "../Scripts/goodsdetail.js?dt=" + DateTime.Now.ToString("yyyyMMddhhmmss"));

        ParseRequestParameters();
       

        if (IsPostBack == false)
        {
            DefaultDataBind();
            SaveGoodsSearchLog();
            SaveCategorySearchLog();
        }
    }

    #region <<파라미터 Get>>
    protected void ParseRequestParameters()
    {
        if (Request.Cookies["Svid_User"] != null)
        {
            SvidUser = Request.Cookies["Svid_User"].Value.AsText();
        }
        FinalCategoryCode = Request.QueryString["CategoryCode"].AsText();
        GoodsGroupCode = Request.QueryString["GroupCode"].AsText();
        GoodsCode = Request.QueryString["GoodsCode"].AsText();
    }

    #endregion

    #region <<데이터바인드>>
    protected void DefaultDataBind()
    {
        //GetCategoryName();
        //SetAuthFunction();
        GetUserRole();
        //GetGoodsInfo();
    }

    //로그인유저/로그인안한유저 별 기능 권한 세팅
    protected void SetAuthFunction() {
        //if (!string.IsNullOrWhiteSpace(SvidUser))
        //{
        //    headerButtonDiv.Visible = true;
        //    bottomButtonDiv.Visible = true;
        //}
        //else
        //{
        //    headerButtonDiv.Visible = false;
        //    bottomButtonDiv.Visible = false;
        //}
    }
    //protected void GetCategoryName()
    //{
    //    var paramList = new Dictionary<string, object> {
    //        {"nvar_P_CATEGORYFINALCODE", FinalCategoryCode},

    //    };
    //    var categoryName = CategoryService.GetCategoryCurrentName(paramList);

    //    lbCategory.Text = categoryName;
    //}

    protected void GetUserRole()
    {

        if (Request.Cookies["LoginID"] != null)
        {
            var sesstionId = Request.Cookies["LoginID"].Value.AsText();
            var paramList = new Dictionary<string, object>
            {
                { "nvar_P_ID", sesstionId},  //로그인 session값 추가
            };
            var user = UserService.GetUser(paramList);
            if (user != null)
            {
                SvidRole = user.Svid_Role;
                Gubun = user.Gubun;
                if (user.UserInfo != null)
                {
                    PriceCompCode = user.UserInfo.PriceCompCode;
                    CompCode = user.UserInfo.Company_Code;
                    BmroCheck = user.UserInfo.BmroCheck;
                    SaleCompCode = user.UserInfo.SaleCompCode;
                    FreeCompanyYN = user.UserInfo.FreeCompanyYN;
                    FreeCompanyVatYN = user.UserInfo.FreeCompanyVATYN.AsText("N");

                   
                }

            }
            //ucLeftMenu.CompCode = CompCode;
            //ucLeftMenu.SaleCompCode = SaleCompCode;
            //ucLeftMenu.BdongshinCheck = DongshinCheck;

        }
    }

    protected void GetGoodsInfo()
    {

    }

    protected void SaveGoodsSearchLog() {

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
            {"nvar_P_GROUPCODE", GoodsGroupCode},
            {"nvar_P_GOODSCODE", GoodsCode},
            {"nvar_P_GUBUN", Gubun},
            {"nvar_P_SVID_USER", svidUser}
        };

        
        GoodsService.SaveGoodsSearchLog(paramList);
    }


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

    #endregion

    #region <<이벤트>>

    #endregion
}