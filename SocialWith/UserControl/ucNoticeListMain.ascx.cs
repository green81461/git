using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Board;

public partial class UserControl_ucNoticeListMain : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            GetNoticeList();
        }
    }

    protected void GetNoticeList() {

        BoardService boardService = new BoardService();
        var paramList = new Dictionary<string, object>
        {
        };
        var list = boardService.GetNoticeListMain(paramList);
        string title = string.Empty;
        if (list != null && list.Count > 0)
        {
            foreach (var item in list)
            {
                title += "<span onclick='fnGoNoticeView(\"" + item.Svid_Board.Trim() + "\")' style='cursor:pointer; color:black;'>" + Truncate(item.Board_Title.Trim(), 20) + "</span><br/>";
            }
            lblnoticeList.Text = title;
        }
        
    }

    public static string Truncate(string value, int maxChars)
    {
        return value.Length <= maxChars ? value : value.Substring(0, maxChars) + "...";
    }
}