using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;

public partial class Admin_Company_CompManagementInfo : AdminPageBase
{
    protected string Ucode;
    //SocialWith.Biz.Comapny.CompanyService companyService = new SocialWith.Biz.Comapny.CompanyService();

    protected string qsCompCode = string.Empty; //회사코드
    protected string qsCompNo = string.Empty; //사업자번호
    protected string qsGubun = string.Empty; //구분(A/B)

    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
    }

    #region <<파라미터 Get>>
    protected void ParseRequestParameters()
    {
        qsCompCode = Request.QueryString["compCode"].AsText();
        qsCompNo = Request.QueryString["compNo"].AsText();
        qsGubun = Request.QueryString["gubun"].AsText();
        Ucode = Request.QueryString["ucode"].ToString();
    }
    #endregion

}