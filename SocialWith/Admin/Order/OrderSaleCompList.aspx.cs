using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;

public partial class Admin_Order_OrderSaleCompList : AdminPageBase
{
    protected string Ucode;
    SocialWith.Biz.Comapny.CompanyService companyService = new SocialWith.Biz.Comapny.CompanyService();
    protected int PageSize = 20; //페이징 사이즈

    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        if (!IsPostBack)
        {
            ddlSearchBelong.SelectedIndex = 0;
            DefaultDataBind();
        }
    }

    protected void ParseRequestParameters()
    {
        //  Svid = Request.QueryString["Svid"].ToString();
        Ucode = Request.QueryString["ucode"].AsText();
    }

    #region << 데이터 바인드 >>
    protected void DefaultDataBind()
    {
        GetOrderBelongList(); //셀렉트박스의 주문소속 목록 조회
    }

    //셀렉트박스의 주문소속 목록 조회
    protected void GetOrderBelongList()
    {
        ddlSearchBelong.Items.Clear();
        
        var paramList = new Dictionary<string, object> { };
        var belongLIst = companyService.GetOrderBelongList(paramList);

       
        ddlSearchBelong.DataSource = belongLIst;
        ddlSearchBelong.DataTextField = "OrderBelongName";
        ddlSearchBelong.DataValueField = "OrderBelongCode";
        ddlSearchBelong.DataBind();
        ddlSearchBelong.Items.Insert(0, new ListItem(":::전체:::", "All"));
        ddlSearchBelong.SelectedIndex = 0;

        GetOrderAreaList();
    }

    //주문 지역 목록 조회
    protected void GetOrderAreaList()
    {
       
        var paramList = new Dictionary<string, object> {
            {"nvar_P_ORDERBELONG_CODE", ddlSearchBelong.SelectedValue}
        };

        var areaList = companyService.GetOrderAreaList(paramList);

        ddlSearchArea.DataSource = areaList;
        ddlSearchArea.DataTextField = "OrderAreaName";
        ddlSearchArea.DataValueField = "OrderAreaCode";
        ddlSearchArea.DataBind();
        ddlSearchArea.Items.Insert(0, new ListItem(":::전체:::", "All"));
        ddlSearchArea.SelectedIndex = 0;

        GetOrderSaleCompList(1);
    }

    protected void GetOrderSaleCompList(int page = 1)
    {
        var paramList = new Dictionary<string, object> {
            {"nvar_P_ORDERBELONG_CODE", ddlSearchBelong.SelectedValue.AsText()},
            {"nvar_P_ORDERAREA_CODE", ddlSearchArea.SelectedValue.AsText()},
            {"nvar_P_ORDERSALECOMPANY_NAME", txtSearchSaleCompNm.Text.AsText()},
            {"inte_P_PAGENO", page},
            {"inte_P_PAGESIZE", PageSize}
        };

        var list = companyService.GetOrderSaleCompList(paramList);

        int listCount = 0;
        if (list != null)
        {
            if(list.Count > 0)
            {
                listCount = list.FirstOrDefault().TotalCount;
            }
            ucListPager.TotalRecordCount = listCount;
        }

        lvSaleCompList.DataSource = list;
        lvSaleCompList.DataBind();
    }
    #endregion

    #region << 이벤트 >>

    //주문소속 셀렉트박스 이벤트
    protected void ddlSearchBelong_Changed(object sender, EventArgs e)
    {
        GetOrderAreaList();
    }

  
    

    protected void lvSaleCompList_ItemDataBound(object sender, ListViewItemEventArgs e)
    {

    }

    protected void ucListPager_PageIndexChange(object sender)
    {
        GetOrderSaleCompList(ucListPager.CurrentPageIndex);
    }


    protected void btnPopupSave_Click(object sender, EventArgs e)
    {
       

        var param = new Dictionary<string, object> {
            {"P_SALECOMPANYCODE" ,hfBaseOrderSaleCompCode.Value.Trim()},
            {"P_AREACODE" ,hfAreaCode.Value.Trim()},
            {"P_BELONGCODE" ,hfBelongCode.Value.Trim()},
            {"P_NEWSALECOMPANAYCODE" ,hfNewCompCode.Value.Trim()},
            {"P_NEWSALECOMPANAYNAME" ,hfNewCompName.Value.Trim()},
            {"P_NEWSALECOMPANAYNO",hfNewCompNo.Value.Trim()},
            {"P_GUBUN" ,hfNewGubun.Value.Trim()},
            {"P_REMARK" ,txtRemark.Text.Trim()},
        };
        companyService.UpdateOrderSaleCompInfo(param);
        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('저장되었습니다.');</script>");
        GetOrderSaleCompList(1);
    }
    #endregion


    protected void imgSearch_Click(object sender, EventArgs e)
    {
        GetOrderSaleCompList();
    }
}