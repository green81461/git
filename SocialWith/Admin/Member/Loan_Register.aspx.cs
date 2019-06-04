using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Comapny;
using SocialWith.Biz.User;
using Urian.Core;

public partial class Admin_Member_Loan_Register : AdminPageBase
{
    protected string Ucode;
    UserService UserService = new UserService();
    CompanyService CompanyService = new CompanyService();
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
        CompanyDataBind();
    }

    protected void CompanyDataBind(int page = 1)
    {
        //var paramList = new Dictionary<string, object> {
        //    {"nvar_P_SEARCHKEYWORD", txtSearch.Text.Trim() },        
        //    {"inte_P_PAGENO", page },
        //    {"inte_P_PAGESIZE", 6 }
        //};


        //var list = UserService.Update_PG_Company(paramList);
        //int listCount = 0;
        //if (list != null)
        //{
        //    if (list.Count > 0)
        //    {
        //        listCount = list.FirstOrDefault().TotalCount;
        //    }
        //}

        //ucListPager.TotalRecordCount = listCount;

        //lvBrandList.DataSource = list;
        //lvBrandList.DataBind();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        CompanyDataBind();
        //   ucListPager.CurrentPageIndex = 1;
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
        //유니크로 ReadOnly 값 받아오기
        string txtComCodeU = Request[this.txtComCode.UniqueID];
        string txtComNoU = Request[this.txtComNo.UniqueID];
        var paramList = new Dictionary<string, object>
        {
           {"nvar_P_COMPANY_CODE",txtComCodeU.Trim() },
           {"nvar_P_COMPANY_NO",txtComNoU.Trim() },
           {"nvar_P_MAP_POINT",mapPoint.Text.Trim() },
           {"nvar_P_SVID_USER",Svid_User },
           {"nvar_P_VERK",Verk.Text.Trim() },
           {"nvar_P_DELFLAG","Y" },
           {"nvar_P_REMARK",txtRemark.Text.Trim() },
           {"nvar_P_SALECOMNAME",txtComName.Text.Trim() },
           {"nvar_P_BUYCOMNAME",txtBuyCom.Text.Trim() }
        };
        CompanyService.SaveLoanInsert(paramList);
        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('저장되었습니다.');</script>");
        Response.Redirect(string.Format("Loan_Main.aspx?ucode="+ Ucode)); //메인으로 가기.
    }
}


