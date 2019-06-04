using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.ReturnChange;
using Urian.Core;

public partial class Goods_ReturnExchangeStatus : PageBase
{
    ReturnChangeService returnChangeService = new ReturnChangeService();
    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack == false)
        {
            StatusListBind();
        }
    }

    #region << 데이터바인드 >>
    protected void StatusListBind(int page = 1)
    {
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", Svid_User },
            {"nvar_P_SEARCHTARGET",ddlSearchTarget.SelectedValue },
            { "nvar_P_SEARCHKEYWORD", txtSearch.Text.AsText().Trim() },
            {"inte_P_PAGENO", page },
            {"inte_P_PAGESIZE", 20 }
        };
        
        var list = returnChangeService.GetReturnChangeList(paramList);
        
        int listCount = 0;
        if ((list != null) && (list.Count > 0))
        {
            listCount = list.FirstOrDefault().TotalCount;
        }
        
        ucListPager.TotalRecordCount = listCount;
        lvStatusList.DataSource = list;
        lvStatusList.DataBind();
    }
    #endregion

    #region << 페이징 이벤트 >>
    protected void ucListPager_PageIndexChange(object sender)
    {
        StatusListBind(ucListPager.CurrentPageIndex);
    }
    #endregion


    protected void btnStatSearch_Click(object sender, EventArgs e)
    {
        StatusListBind();
    }
}