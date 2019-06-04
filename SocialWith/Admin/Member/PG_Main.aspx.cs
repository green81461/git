using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.User;
using SocialWith.Biz.Category;
using SocialWith.Biz.Goods;

public partial class Admin_Member_PG_Main : AdminPageBase
{
    protected string Ucode;
    GoodsService GoodsService = new GoodsService();
    UserService UserService = new UserService();
    CategoryService categoryService = new CategoryService();
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
        //PGDataBind();
    }

    //protected void PGDataBind(int page = 1)
    //{

    //    var paramList = new Dictionary<string, object> {
    //        {"nvar_P_SEARCHKEYWORD", txtSearch.Text.Trim() },
    //      //{"nvar_P_SERACHTARGET",ddlSearchTarget.SelectedValue },
    //        {"nvar_P_SERACHTARGET","All" },
    //      //{"char_P_DELFLAG",ddlSearchDelFlag.SelectedValue },
    //        {"inte_P_PAGENO", page },
    //        {"inte_P_PAGESIZE", 20 },
    //    };


    //    var list = UserService.Get_PG_List_Admin(paramList);
    //    int listCount = 0;
    //    //if (list != null)
    //    //{
    //    //    if (list.Count > 0)
    //    //    {
    //    //        listCount = list.FirstOrDefault().TotalCount;
    //    //    }
    //    //}

    //    if ((list != null) && (list.Count > 0))
    //    {
    //        listCount = list.FirstOrDefault().TotalCount;
    //    }


    //    ucListPager.TotalRecordCount = listCount;
    //    lvBrandList.DataSource = list;
    //    lvBrandList.DataBind();
    //}

    //protected void Click_save(object sender, EventArgs e)
    //{
    //    var paramList = new Dictionary<string, object>
    //    {
    //       {"nvar_P_COMPANY_CODE",txtComCode.Text.Trim() },
    //       {"nvar_P_COMPANY_NO",txtComNo.Text.Trim() },
    //       {"nvar_P_PG_AID",txtAid.Text.Trim() },
    //       {"nvar_P_PG_GID",txtGid.Text.Trim() },
    //       {"nvar_P_PG_MID",txtMid.Text.Trim() },
    //       {"nvar_P_PG_MIDKEY",txtMidKey.Text.Trim()},
    //       {"nvar_P_PG_ARS_MID",txtArsMid.Text.Trim() },
    //       {"nvar_P_PG_ARS_MIDKEY",txtArsKey.Text.Trim() },
    //       {"nvar_P_PG_LOAN_MID",txtLoanMid.Text.Trim() },
    //       {"nvar_P_PG_LOAN_MIDKEY",txtLoanKey.Text.Trim() },
    //       {"nvar_P_SVID_USER",Svid_User },
    //       {"nvar_P_DELFLAG","Y" },
    //       {"nvar_P_REMARK",txtRemark.Text.Trim() },
    //       {"nvar_P_PG_MOBILE_MID",txtMobileMId.Text.Trim() },
    //       {"nvar_P_PG_MOBILE_MIDKEY",txtMobileKey.Text.Trim() }
    //    };
    //    GoodsService.SavePgUpdate(paramList);
    //    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('저장되었습니다.');</script>");
    //    Response.Redirect(string.Format("PG_Main.aspx?ucode="+Ucode)); //메인으로 가기.

    //}


    //protected void btnSearch_Click(object sender, EventArgs e)
    //{
    //    PGDataBind(1);
    //    ucListPager.CurrentPageIndex = 1;
    //}
    //protected void ucListPager_PageIndexChange(object sender)
    //{
    //    PGDataBind(ucListPager.CurrentPageIndex);
    //}

    //protected void lvBrandList_ItemDataBound(object sender, ListViewItemEventArgs e)
    //{
    //    if (e.Item.ItemType == ListViewItemType.DataItem)         //구분값에 따른 컬럼 헤더 visible처리
    //    {
    //        ListViewDataItem dataItem = (ListViewDataItem)e.Item;

    //        ImageButton ibtnBrandDelete = (ImageButton)dataItem.FindControl("ibtnBrandDelete");
    //        ImageButton ibtnBrandUse = (ImageButton)dataItem.FindControl("ibtnBrandUse");
    //        HiddenField hfDelFlag = (HiddenField)dataItem.FindControl("hfDelFlag");

    //        if (ibtnBrandDelete != null && ibtnBrandUse != null && hfDelFlag != null)
    //        {
    //            if (hfDelFlag.Value == "N" || string.IsNullOrWhiteSpace(hfDelFlag.Value))
    //            {
    //                ibtnBrandDelete.Visible = true;
    //                ibtnBrandUse.Visible = false;
    //            }
    //            else
    //            {
    //                ibtnBrandDelete.Visible = false;
    //                ibtnBrandUse.Visible = true;
    //            }
    //        }
    //    }
    //}






}