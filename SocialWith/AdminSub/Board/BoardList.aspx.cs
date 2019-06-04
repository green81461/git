using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using SocialWith.Data.Comm;
using Urian.Core;

public partial class AdminSub_Board_BoardList : AdminSubPageBase
{
    protected int CurrentPage;
    protected SocialWith.Biz.Comm.CommService commService = new SocialWith.Biz.Comm.CommService();
    protected string boardChannel = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        
        if (IsPostBack == false)
        {
            GetCommList();
            BoardBind();
           
        }
    }

    protected void ParseRequestParameters()
    {
        boardChannel = Request.QueryString["boardChannel"].AsText();
    }

    protected void GetCommList()
    {
        SocialWith.Biz.Comm.CommService CommService = new SocialWith.Biz.Comm.CommService();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPCODE", "BOARD"},
            { "nume_P_MAPCHANEL", 1},
        };

        var list = CommService.GetCommList(paramList);

        if ((list != null) && (list.Count > 0))
        {
            foreach (var item in list)
            {
                if (item.Map_Type != 0)
                {
                    ddlComm.Items.Add(new ListItem(item.Map_Name, item.Map_Channel + "_" + item.Map_Type));
                }
            }
        }
        if (!string.IsNullOrWhiteSpace(boardChannel))
        {
            ddlComm.SelectedValue = boardChannel;
        }
       
    }

    protected void BoardBind(int page =1)
    {
        var service = new SocialWith.Biz.Board.BoardService();
        //var svidUser = HttpContext.Current.Session["Svid_User"];
        
        var paramList = new Dictionary<string, object> {
             {"nvar_P_MAPCHANNEL", !string.IsNullOrWhiteSpace(ddlComm.SelectedValue) ? ddlComm.SelectedValue.Split('_')[0] : ""},
            {"nvar_P_MAPTYPE", !string.IsNullOrWhiteSpace(ddlComm.SelectedValue) ? ddlComm.SelectedValue.Split('_')[1] : "" },
            {"nvar_P_SEARCHKEYWORD", txtSearch.Text.Trim() },
            {"nvar_P_SERACHTARGET",ddlSearchTarget.SelectedValue },
            {"inte_P_PAGENO", page },
            {"inte_P_PAGESIZE", 20 },
            {"inte_P_BOARD_GUBUN", 1 }, // 1:1문의 구분코드
            {"nvar_P_BOARD_USER", Svid_User }
        };
        
        var list = service.GetaAdminSubBoardList(paramList);
        int listCount = 0;
        if (list != null)
        {
            if (list.Count > 0)
            {
                listCount = list.FirstOrDefault().TotalCount;

                var commList = GetCommList("BOARD", list.FirstOrDefault().Board_Channel); // 문의구분 목록 조회

                for (int i = 0; i < list.Count; i++)
                {
                    foreach (var commItem in commList)
                    {
                        if (list[i].Board_Type.Equals(commItem.Map_Type.ToString()))
                        {
                            list[i].QueryGubunNm = commItem.Map_Name;
                        }
                    }
                }
            }
        }
        
        
        ucListPager.TotalRecordCount = listCount;
        lvBoardList.DataSource = list;
        lvBoardList.DataBind();
    }

    // 문의구분 목록 조회
    protected List<CommDTO> GetCommList(string mapCode, int mapChanel)
    {
        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_MAPCODE", mapCode },
            {"inte_P_MAPCHANEL", mapChanel }
        };

        var list = commService.GetCommList(paramList);

        return list;
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BoardBind();
    }

    protected void ucListPager_PageIndexChange(object sender)
    {
        BoardBind(ucListPager.CurrentPageIndex);
    }


    protected string SetResultStatusText(string status)
    {
        string returnVal = string.Empty;

        if (status == "Y")
        {
            returnVal = "답변완료";
        }
        else
        {
            returnVal = "진행중";
        }

        return returnVal;
    }
    //protected void lvBoardList_ItemDataBound(object sender, ListViewItemEventArgs e)
    //{
    //    if (e.Item.ItemType == ListViewItemType.DataItem)
    //    {

    //        var lbButton = (LinkButton)e.Item.FindControl("lbPwdModal");
    //        var hfPwd = (HiddenField)e.Item.FindControl("hfPwd");
    //        var hfSvid = (HiddenField)e.Item.FindControl("hfSvid");
    //        lbButton.Attributes.Add("onclick" , String.Format("fnPwdModal(\"{0}\",\"{1}\",\"{2}\"); return false;", hfPwd.Value, hfSvid.Value, txtPwd.Text.Trim()));

    //    }
    //}
}