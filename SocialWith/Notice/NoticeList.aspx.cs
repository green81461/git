using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NLog;
using System.Collections;

public partial class Notice_NoticeList : PageBase
{
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
            BoardBind();
        }
    }

    protected void ParseRequestParameters()
    {
    }

    protected void BoardBind(int page =1)
    {
        var service = new SocialWith.Biz.Board.BoardService();
        var svidUser = Request.Cookies["Svid_User"].Value;

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHKEYWORD", txtSearch.Text.Trim() },
            {"nvar_P_SERACHTARGET",ddlSearchTarger.SelectedValue },
            {"inte_P_PAGENO",page },
            {"inte_P_PAGESIZE", 20 },
            {"inte_P_BOARD_GUBUN", 13 },
            {"nvar_P_BOARD_USER", svidUser },
            {"nvar_P_ISADMIN", "False" },
         };

        var list = service.GetNoticeList(paramList);
        int listCount = 0;
        if ((list != null) && (list.Count > 0))
        {
            listCount = list.FirstOrDefault().TotalCount;
        }

        ucListPager.TotalRecordCount = listCount;
        lvBoardList.DataSource = list;
        lvBoardList.DataBind();
    }



    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BoardBind();
    }



    protected void ucListPager_PageIndexChange(object sender)
    {
        BoardBind(ucListPager.CurrentPageIndex);
    }
}