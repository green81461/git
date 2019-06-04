using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Order;

using Urian.Core;

public partial class Admin_Order_OrderBelongRegister : AdminPageBase
{
    protected string Ucode;
    OrderService OrderService = new OrderService();

    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        if (IsPostBack == false)
        {
            DefaultDataBind();
            ibCodeCreate_Click();
        }
    }
    protected void ParseRequestParameters()
    {

        //  Svid = Request.QueryString["Svid"].ToString();
        Ucode = Request.QueryString["ucode"].ToString();
    }
    //코드 자동 생성 함수  
    protected void ibCodeCreate_Click()
    {

        var paramList = new Dictionary<string, object>
        {

        };
        string lastCode = OrderService.GetComCodeNo(paramList);

        if ((lastCode == null) || (lastCode == ""))  //값이 있으면 false
        {
            hfComCodeNo.Value = txtOdrCode.Text = "AA001";           //U_OrderBelong 테이블의 값이 없을 경우 AA001 기본값으로. 
        }

        else
        {
            string firstCh = lastCode.Substring(0, 2).AsText("AA");
            string currentCodeExNo = lastCode.Substring(2, 3).AsText("000");
            string nextCodeExNo = (currentCodeExNo.AsInt() + 1).ToString("000");
            hfComCodeNo.Value = txtOdrCode.Text = firstCh + nextCodeExNo;
        }
    }

    protected void DefaultDataBind()
    {
        CompanyDataBind();
    }

    protected void CompanyDataBind(int page = 1)
    {

    }




    protected void lvBrandList_ItemDataBound(object sender, ListViewItemEventArgs e)
    {
        if (e.Item.ItemType == ListViewItemType.DataItem)         //구분값에 따른 컬럼 헤더 visible처리
        {
            ListViewDataItem dataItem = (ListViewDataItem)e.Item;

            ImageButton ibtnBrandDelete = (ImageButton)dataItem.FindControl("ibtnBrandDelete");
            ImageButton ibtnBrandUse = (ImageButton)dataItem.FindControl("ibtnBrandUse");
            HiddenField hfDelFlag = (HiddenField)dataItem.FindControl("hfDelFlag");

            if (ibtnBrandDelete != null && ibtnBrandUse != null && hfDelFlag != null)
            {
                if (hfDelFlag.Value == "N" || string.IsNullOrWhiteSpace(hfDelFlag.Value))
                {
                    ibtnBrandDelete.Visible = true;
                    ibtnBrandUse.Visible = false;
                }
                else
                {
                    ibtnBrandDelete.Visible = false;
                    ibtnBrandUse.Visible = true;

                }
            }
        }
    }

    protected void ucListPager_PageIndexChange(object sender)
    {
        //  CompanyDataBind(ucListPager.CurrentPageIndex);
    }



    protected void ibSave_Click(object sender, EventArgs e)
    {
        var paramList = new Dictionary<string, object>
        {
           {"nvar_P_ORDERBELONG_CODE",txtOdrCode.Text.Trim() },
           {"nvar_P_ORDERBELONG_NAME",txtOdrName.Text.Trim() },
           {"nvar_P_DELFLAG","N"},
           {"nvar_P_REMARK",txtRemark.Text.Trim() }
        };
        OrderService.OrderBelong_Insert(paramList);
        Response.Redirect(string.Format("OrderBelongMain.aspx?ucode="+ Ucode)); //메인으로 가기.
    }
}


