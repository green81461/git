using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Order;


public partial class Admin_Order_OrderBelongMain : AdminPageBase
{
    protected string Ucode;
    OrderService OrderService = new OrderService();

    protected string txtDel;

    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        if (IsPostBack == false)
        {
            DefaultDataBind();
        }
    }


    protected void ParseRequestParameters()
    {

        //  Svid = Request.QueryString["Svid"].ToString();
        Ucode = Request.QueryString["ucode"].ToString();
    }
    protected void DefaultDataBind()
    {
        OrderBelongDataBind();
    }

    //주문연동관리 - 주문소속 조회  
    protected void OrderBelongDataBind(int page = 1)
    {

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHKEYWORD", txtSearch.Text.Trim() },
            {"inte_P_PAGENO", page },
            {"inte_P_PAGESIZE", 20 }
        };


        var list = OrderService.OrderBelong_List(paramList);
        int listCount = 0;
        if (list != null)
        {
            if (list.Count > 0)
            {
                listCount = list.FirstOrDefault().TotalCount;
            }
        }

        ucListPager.TotalRecordCount = listCount;
        lvBrandList.DataSource = list;
        lvBrandList.DataBind();


      
    }

    protected string SetFlagName(string value)
    {

        string returnVal = "사용";
        if (!string.IsNullOrWhiteSpace(value))
        {
            if (value == "N")
            {
                returnVal = "사용";
            }
            else
            {
                returnVal = "사용중지";
            }
        }

        return returnVal;
    }


   

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        OrderBelongDataBind();
        ucListPager.CurrentPageIndex = 1;
    }
    protected void ucListPager_PageIndexChange(object sender)
    {
        OrderBelongDataBind(ucListPager.CurrentPageIndex);
    }


    // 사용중 && 사용중지 버튼  
    protected void lvBrandList_ItemDataBound(object sender, ListViewItemEventArgs e)
    {
        if (e.Item.ItemType == ListViewItemType.DataItem)         //구분값에 따른 컬럼 헤더 visible처리
        {
            ListViewDataItem dataItem = (ListViewDataItem)e.Item;

            ImageButton ibtnCategoryDelete = (ImageButton)dataItem.FindControl("ibtnCategoryDelete");
            ImageButton ibtnCategoryUse = (ImageButton)dataItem.FindControl("ibtnCategoryUse");
            HiddenField hfDelFlag = (HiddenField)dataItem.FindControl("hfDelFlag");

            if (ibtnCategoryDelete != null && ibtnCategoryUse != null && hfDelFlag != null)
            {
                if (hfDelFlag.Value == "Y" || string.IsNullOrWhiteSpace(hfDelFlag.Value))
                {
                    ibtnCategoryDelete.Visible = true;
                    ibtnCategoryUse.Visible = false;
                
                }
                else
                {
                    ibtnCategoryDelete.Visible = false;
                    ibtnCategoryUse.Visible = true;
               
                }
            }
        }
    }




}