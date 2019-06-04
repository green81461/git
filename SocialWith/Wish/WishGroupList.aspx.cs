using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Wish;
using Urian.Core;

public partial class Wish_WishGroupList : PageBase
{
    //string Svid_User = string.Empty;
    WishService WishService = new WishService();

    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;
    }

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
        //Svid_User = Request.QueryString["Svid_User"].AsText("09f7ce64-8bdf-49a6-8515-a70fd24a5361");
    }

    #endregion

    #region <<데이터바인드>>
    protected void DefaultDataBind()
    {
        GetWishGroupList();
    }

    protected void GetWishGroupList(int page = 1) {

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHKEYWORD", txtSearchGroupName.Text.Trim() },
            {"inte_P_PAGENO", page },
            {"inte_P_PAGESIZE", 20 },
            {"nvar_P_SVID_USER", Svid_User }, 
        };

        int listCount = 0;
        var list = WishService.GetWishGroupList(paramList);

        if ((list != null) && (list.Count > 0))
        {
            listCount = list.FirstOrDefault().TotalCount;
        }

        ucListPager.TotalRecordCount = listCount;
        lvWishGroupList.DataSource = list;
        lvWishGroupList.DataBind();
    }

    #endregion

    #region <<이벤트>>

    //protected void btnSearch_Click(object sender, EventArgs e)
    //{
    //    GetWishGroupList();
    //}


    //protected void btnSearch_Click(object sender, ImageClickEventArgs e)
    //{
    //    GetWishGroupList();
    //}

    protected void ucListPager_PageIndexChange(object sender)
    {
        GetWishGroupList(ucListPager.CurrentPageIndex);
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        var paramList = new Dictionary<string, object> {
            {"nvar_P_UWISHLISTGROUPNAME", txtGroupName.Text.Trim() },
            {"nvar_P_UWISHLISTGROUPCONTEXT", txtGroupContent.Text.Trim() },
            {"nvar_P_SVID_USER", Svid_User },
            {"reVa_P_RETURN_RESULT", 0 },
        };

       int result =  WishService.SaveWishListGroup(paramList);

        if (result == 1 )
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('저장되었습니다.');</script>");
            GetWishGroupList();
        }
        else if (result == 2)
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('중복된 보관함 명이 있습니다.');</script>");
        }
       
    }

    protected void lvWishGroupList_ItemCommand(object sender, ListViewCommandEventArgs e)
    {
        if (e.CommandName == "Delete")
        {
            var num = e.CommandArgument.AsInt();  //svid delivery 를 갖고온다

            var paramList = new Dictionary<string, object> {
                 { "nvar_SVID_USER",num},
                 { "nume_P_UNUM_WISHLISTGROUP",num}
             };
            WishService.DeleteWishListGroup(paramList);
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('삭제되었습니다.');</script>");
            GetWishGroupList();
        }
     }

    protected void lvWishGroupList_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {

    }

    #endregion


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        GetWishGroupList();
    }
}