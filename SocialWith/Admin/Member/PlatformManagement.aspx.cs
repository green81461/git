using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Platform;

public partial class Admin_Member_PlatformManagement : AdminPageBase
{
    protected string Ucode;
    PlatformService platformService = new PlatformService();
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

    #region <<데이터바인드>>
    protected void DefaultDataBind()
    {
        PlatformDataBind();
    }

    protected void PlatformDataBind(int page = 1)
    {
        var paramList = new Dictionary<string, object> {
            {"char_P_DELFLAG",ddlSearchDelFlag.SelectedValue },
            {"nvar_P_SEARCHKEYWORD", txtSearch.Text.Trim() },
            {"nvar_P_SERACHTARGET",ddlSearchTarget.SelectedValue },
            {"inte_P_PAGENO", page },
            {"inte_P_PAGESIZE", 20 },
        };

        var list = platformService.PlatformList(paramList);
        int listCount = 0;
        if (list != null)
        {
            if (list.Count > 0)
            {
                listCount = list.FirstOrDefault().TotalCount;
            }
        }

        ucListPager.TotalRecordCount = listCount;
        lvPlatformList.DataSource = list;
        lvPlatformList.DataBind();
    }

    protected void lvList_ItemDataBound(object sender, ListViewItemEventArgs e)
    {
        if (e.Item.ItemType == ListViewItemType.DataItem)         //구분값에 따른 컬럼 헤더 visible처리
        {
            ListViewDataItem dataItem = (ListViewDataItem)e.Item;

            ImageButton ibtnBrandDelete = (ImageButton)dataItem.FindControl("ibtnDelete");
            ImageButton ibtnBrandUse = (ImageButton)dataItem.FindControl("ibtnUse");
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
        PlatformDataBind(ucListPager.CurrentPageIndex);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        PlatformDataBind();
        ucListPager.CurrentPageIndex = 1;
    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_TYPE", "B" },
            { "nvar_P_URIANBORDERTCODE", hfPopupCode.Value.Trim() },
            { "char_P_DELFLAG", "" },
            { "nvar_P_URIANBORDERTNAME", txtPopupName.Text.Trim()},
            { "nvar_P_REMARK", txtPopupRemark.Text.Trim() },
        };

        platformService.PlatformTypeMgt(paramList);
        PlatformDataBind();
    }

    #endregion
}