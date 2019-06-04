using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;
using SocialWith.Biz.User;
using SocialWith.Biz.Comapny;

public partial class Admin_Member_MemberCorpInfo_A : AdminPageBase
{
    protected string uId = string.Empty;
    protected string gubunCode = string.Empty;
    protected string gubunCodeNm = string.Empty;
    protected string compCode = string.Empty;
    protected string compCodeNm = string.Empty;
    protected string areaCode = string.Empty;
    protected string areaCodeNm = string.Empty;
    protected string businessCode = string.Empty;
    protected string businessCodeNm = string.Empty;
    protected string deptCode = string.Empty;
    protected string deptCodeNm = string.Empty;
    protected string compNo = string.Empty;
    protected string svidUser = string.Empty;

    protected string billUserNm = string.Empty;
    protected string billTel = string.Empty;
    protected string billFax = string.Empty;
    protected string billEmail = string.Empty;
    protected string uptae = string.Empty;
    protected string upjong = string.Empty;
    protected string ucode = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        if (!IsPostBack)
        {
            DefaultDataBind();
        }
    }

    #region <<파라미터 Get>>
    protected void ParseRequestParameters()
    {
        uId = Request.QueryString["uId"].AsText();
        ucode = Request.QueryString["ucode"].AsText();
    }
    #endregion

    #region <<데이터바인딩>>
    protected void DefaultDataBind()
    {
        var paramList = new Dictionary<string, object>() {
            {"nvar_P_ID", uId}
        };

        UserService userService = new UserService();

        //회사정보 저장에 필요한 데이터를 갖고온다
        var user = userService.GetUser(paramList);
        if (user != null)
        {
            compNo = user.UserInfo.Company_No;
            lblCompNo.Text = user.UserInfo.Company_No;
            gubunCode = user.Gubun;
            gubunCodeNm = user.Gubun_Name;
            compCode = user.UserInfo.Company_Code;
            compCodeNm = user.UserInfo.Company_Name;
            areaCode = user.UserInfo.CompanyArea_Code;
            if (areaCode.Equals("0")) areaCode = "";
            areaCodeNm = user.UserInfo.CompanyArea_Name;
            businessCode = user.UserInfo.CompBusinessDept_Code;
            businessCodeNm = user.UserInfo.CompBusinessDept_Name;
            deptCode = user.UserInfo.CompanyDept_Code;
            deptCodeNm = user.UserInfo.CompanyDept_Name;
            svidUser = user.Svid_User;

            //세금계산서 부분
            //billUserNm = user.Name;
            //billTel = user.TelNo;
            //billFax = user.FaxNo;
            //billEmail = Crypt.AESDecrypt256(user.Email);
            //uptae = user.UserInfo.Uptae;
            //upjong = user.UserInfo.Upjong;

            GetCompanyInfo(compNo, compCode, gubunCode.Substring(0, 2)); // 회사정보 조회

            //배송지레벨, 부분 추가 작업 필요.......

        }
    }

    //회사정보 조회(세금계산서용)
    protected void GetCompanyInfo(string compNo, string compCode, string gubun)
    {
        var paramList = new Dictionary<string, object> {
           { "nvar_P_COMPANY_CODE", compCode},
           { "nvar_P_COMPANY_NO", compNo},
           { "nvar_P_GUBUN", gubun}
        };

        CompanyService companyService = new CompanyService();

        var info = companyService.GetCompanyMngtInfo_Admin(paramList);

        if (info != null)
        {
            billUserNm = info.BillUserNm;
            billTel = info.BillTel;
            billFax = info.BillFax;
            billEmail = info.BillEmail;
            uptae = info.Uptae;
            upjong = info.Upjong;
        }
    }
    #endregion
}