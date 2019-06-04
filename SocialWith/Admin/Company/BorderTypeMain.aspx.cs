using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.ComponentModel.DataAnnotations;
using System.Drawing;
using System.Reflection;
using SocialWith.Biz.Comapny;

public partial class Admin_Company_BorderTypeMain : AdminPageBase
{
    protected string Ucode;
    CompanyService companyService = new CompanyService();
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();

        if (IsPostBack == false)
        {
            DefaultDataBind();
        }
    }

    #region <<파라미터 Get>>
    protected void ParseRequestParameters()
    {

        //  Svid = Request.QueryString["Svid"].ToString();
        Ucode = Request.QueryString["ucode"].ToString();
    }

    #endregion

    #region <<데이터바인드>>
    protected void DefaultDataBind()
    {
        BorderTypeDataBind();
    }

    protected void BorderTypeDataBind(int page = 1)
    {

        var paramList = new Dictionary<string, object> {
            {"char_P_DELFLAG",ddlSearchDelFlag.SelectedValue },
            {"nvar_P_SEARCHKEYWORD", txtSearch.Text.Trim() },
            {"nvar_P_SERACHTARGET",ddlSearchTarget.SelectedValue },
            {"inte_P_PAGENO", page },
            {"inte_P_PAGESIZE", 20 },
        };

        var list = companyService.GetBorderTypeList(paramList);
        int listCount = 0;
        if (list != null)
        {
            if (list.Count > 0)
            {
                listCount = list.FirstOrDefault().TotalCount;
            }
        }

        ucListPager.TotalRecordCount = listCount;
        lvList.DataSource = list;
        lvList.DataBind();
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
    #endregion

    #region <<이벤트>>

    protected void ucListPager_PageIndexChange(object sender)
    {
        BorderTypeDataBind(ucListPager.CurrentPageIndex);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BorderTypeDataBind();
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

        companyService.BorderTypeMgt(paramList);
        BorderTypeDataBind();
    }
    #endregion


}