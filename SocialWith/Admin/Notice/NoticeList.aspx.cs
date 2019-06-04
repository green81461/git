using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;


public partial class Admin_Notice_NoticeList : AdminPageBase
{
    //protected int CurrentPage;
    protected void Page_Load(object sender, EventArgs e)
    {
       
        ParseRequestParameters();
        if (IsPostBack == false)
        {
            BoardBind();
        }
    }

    protected void ParseRequestParameters()
    {
      //  CurrentPage = string.IsNullOrEmpty(Request.QueryString["page"]) ? 1 : int.Parse(Request.QueryString["page"]);
    }

    protected void BoardBind(int page =1)
    {
        var service = new SocialWith.Biz.Board.BoardService();
        //var svidUser = HttpContext.Current.Session["Svid_Admin"];

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHKEYWORD", txtSearch.Text.Trim() },
            {"nvar_P_SERACHTARGET",ddlSearchTarger.SelectedValue },
            {"inte_P_PAGENO",page },
            {"inte_P_PAGESIZE", 20 },
            {"inte_P_BOARD_GUBUN", 13 },
            {"nvar_P_BOARD_USER", Svid_User },
            {"nvar_P_ISADMIN", "True" },
         };

        var list = service.GetNoticeList(paramList);
        int listCount = 0; 
        if (list !=null && list.Count > 0)
        {
            listCount = list.FirstOrDefault().TotalCount;
        }

        ucListPager.TotalRecordCount = listCount;
        lvBoardList.DataSource = list;
        lvBoardList.DataBind();
    }



    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BoardBind(1);
        ucListPager.CurrentPageIndex = 1;
    }



    protected void ucListPager_PageIndexChange(object sender)
    {
        BoardBind(ucListPager.CurrentPageIndex);
    }
}