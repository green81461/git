using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;

public partial class Admin_Board_SystemListMain : AdminPageBase
{
    protected SocialWith.Biz.Comm.CommService CommService = new SocialWith.Biz.Comm.CommService();
    protected SocialWith.Biz.User.UserService UserService = new SocialWith.Biz.User.UserService();
    protected SocialWith.Biz.SystemUpdate.SystemUpdateService SystemUpdateService = new SocialWith.Biz.SystemUpdate.SystemUpdateService();
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
    }

    #endregion

    #region <<데이터바인드>>
    protected void DefaultDataBind()
    {
        SystemUpdateListBind();
    }

    protected void SystemUpdateListBind(int pageNo =1) {

        var param = new Dictionary<string, object> {
            { "nvar_P_SEARCHKEYWORD",txtSearch.Text.Trim()}
           ,{ "nvar_P_SERACHTARGET",ddlSearchTarget.SelectedValue}
           ,{ "inte_P_PAGENO",pageNo}
           ,{ "inte_P_PAGESIZE",20}
        };

        var list = SystemUpdateService.SystemUpdateList(param);

        int listCount = 0;
        if (list != null)
        {
            if (list.Count > 0)
            {
                listCount = list.FirstOrDefault().TotalCount;
            }
        }


        ucListPager.TotalRecordCount = listCount;
        lvSystemList.DataSource = list;
        lvSystemList.DataBind();

        txtProcessName.Text = UserInfoObject.Name;
    }

    

    //commType get
    protected string GetComm(string code, int channel, int type)
    {

        string returnValue = string.Empty;

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPCODE", code},
            { "nume_P_MAPCHANEL", channel},
            { "nume_P_MAPTYPE", type},
        };

        var comm = CommService.GetComm(paramList);
        if (comm != null)
        {
            returnValue = comm.Map_Name.AsText();
        }

        return returnValue;
    }

    //User get
    protected string GetUser(string svidUser)
    {

        string returnValue = string.Empty;

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SVID_USER", svidUser},
        };

        var user = UserService.GetUserBySvid(paramList);
        if (user != null)
        {
            returnValue = user.Name.AsText();
        }

        return returnValue;
    }

    protected string SetProcessStatusText(string value) {
        string returnValue = string.Empty;

        switch (value)
        {
            case "A":
                returnValue = "진행불가";
                break;
            case "N":
                returnValue = "진행중";
                break;
            case "Y":
                returnValue = "완료";
                break;
            case "Z":
                returnValue = "신청";
                break;
            default:
                returnValue = "신청";
                break;
        }

        return returnValue;
    }

    #endregion

    #region <<이벤트>>

    protected void ucListPager_PageIndexChange(object sender)
    {
        SystemUpdateListBind(ucListPager.CurrentPageIndex);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        SystemUpdateListBind(1);
        ucListPager.CurrentPageIndex = 1;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        var param = new Dictionary<string, object> {
            { "nume_P_UNUM_SYSTEMUPDATENO",hfUnumUpdateNo.Value.Trim()}
           ,{ "nvar_P_PROCESS_USER",Svid_User}
           ,{ "nvar_P_PROCESSRESULT",txtProcessResult.Text.Trim()}
           ,{ "char_P_PROCESSYN",ddlProcessResult.SelectedValue}
        };

        SystemUpdateService.UpdateSystemUpdate(param);

        SystemUpdateListBind(ucListPager.CurrentPageIndex);
    }
    #endregion







}