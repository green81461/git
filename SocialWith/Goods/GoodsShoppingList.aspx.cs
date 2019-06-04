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
        string siteType = ConfigurationManager.AppSettings["SiteType"].AsText();
        string settingDistCssCode = ConfigurationManager.AppSettings["SettingDistCssCode"].AsText();//개발자용 배포코드
        string distCode = "DS00000002"; //기본 사이트배포코드값

        if (siteType == "Localhost")//Webconfig의 SiteType가 Localhost(개발자용)이면 Webconfig의 SettingDistCssCode의값을 갖고온다
        {
            distCode = settingDistCssCode;
        }
        else if (DistCssObject != null) //Webconfig의 SiteType가 Localhost(개발자용)가 아니고 DistCssObject가 널이 아니면 DistCssObject의 코드값을 갖고온다
        {
            distCode = DistCssObject.DistCssCode.AsText("DS00000002"); //사이트배포 데이터가 있으면 해당 코드를 갖고온다
            
        }
        string masterPageUrl = "~/UploadFile/SiteManagement/" + distCode + "/Main/Default.master"; //마스터페이지 분기처리(해당코드경로의 마스터페이지를 갖고옴)
        this.MasterPageFile = masterPageUrl;

    }
    protected string qsCompCode = "";
    protected string qsFullComp = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        goodsCss.Text = string.Format("<link rel=\"stylesheet\" type=\"text/css\" href=\"{0}\"/>", "../Content/Goods/goods.css?dt=" + DateTime.Now.ToString("yyyyMMddhhmmss"));
       
        if (IsPostBack == false)
        {

            DefaultDataBind();
            SaveCategorySearchLog();
        }

        if (Request.Form["CompCode"] != null) //post방식 값 가져오기 (메인화면 가스공사 매출내역 눌렀을때)
        {
            qsCompCode = Request.Form["CompCode"].ToString();
            qsFullComp = Request.Form["FullComp"].ToString();
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