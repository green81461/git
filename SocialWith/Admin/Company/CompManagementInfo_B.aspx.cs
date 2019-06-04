using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;

public partial class Admin_Company_CompManagementInfo_B : AdminPageBase
{
    protected string Ucode;
    SocialWith.Biz.Comapny.CompanyService companyService = new SocialWith.Biz.Comapny.CompanyService();

    protected string qsCompCode = string.Empty; //회사코드
    protected string qsCompNo = string.Empty; //사업자번호
    protected string qsGubun = string.Empty; //구분(A/B)
    protected string BOrdTypeNames = string.Empty; //구매사 주문 유형 명칭모음

    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();

        if (!IsPostBack)
        {
            DefaultDataBInd();
        }
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

    #region << 데이터 바인딩 >>
    protected void DefaultDataBInd()
    {
        DefaultBOrderTypeList(); //구매사 주문 유형
        DefaultBTypeRoleList(); //구매사 결제 선택 유형
    }

    //구매사 주문 유형
    protected void DefaultBOrderTypeList()
    {
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPCODE", "ORDER" },
            { "nume_P_MAPCHANEL", 4 }
        };

        SocialWith.Biz.Comm.CommService commService = new SocialWith.Biz.Comm.CommService();

        var list = commService.GetCommList(paramList);

        if ((list != null) && (list.Count() > 0))
        {
            list[0].Map_Name = "- 주문 유형 선택 -";

            BOrdTypeNames = "^";

            for (int i = 1; i < list.Count(); i++)
            {
                string tmpMapName = list[i].Map_Name;
                var splitMapNm = new string[2] { tmpMapName.Split('^')[0].AsText(), tmpMapName.Split('^')[1].AsText() };

                list[i].Map_Name = splitMapNm[0]; //구매사주문유형코드
                BOrdTypeNames += splitMapNm[1] + "^"; //구매사주문유형명
            }
        }

        ddlBOrdType.DataSource = list;
        ddlBOrdType.DataTextField = "Map_Name";
        ddlBOrdType.DataValueField = "Map_Type";
        ddlBOrdType.DataBind();

        ddlBOrdType.Items[0].Value = "";
    }

    //구매사 결제 선택 유형
    protected void DefaultBTypeRoleList()
    {
        //var paramList = new Dictionary<string, object> { };

        //var list = companyService.GetBTypeRoleList(paramList);

        //ddlBTypeRole.DataSource = list;
        //ddlBTypeRole.DataTextField = "BorderName";
        //ddlBTypeRole.DataValueField = "BorderCode";
        //ddlBTypeRole.DataBind();
        ddlBTypeRole.Items.Insert(0, new ListItem("일반(A)", "A"));

    }
    #endregion
}