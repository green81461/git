using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.User;

public partial class AdminSub_BList_InfoList_B :  AdminSubPageBase
{
    string StartDate;
    string EndDate;
    protected String sdate;
    protected String edate;
    UserService userService = new UserService();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            DefaultDataBind();
        }
    }

    #region <<파라미터 Get>>


    #endregion

    #region <<데이터바인드>>
    protected void DefaultDataBind()
    {
        txtSearchEdate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        txtSearchSdate.Text = DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd");
        //UserListBind();

    }

    //protected void UserListBind(int page = 1) {


    //    sdate = Request[this.txtSearchSdate.UniqueID];
    //    edate = Request[this.txtSearchEdate.UniqueID];

    //    var param = new Dictionary<string, object> {
    //        {"inte_P_PAGENO", page },
    //        {"inte_P_PAGESIZE",20 },
    //        {"nvar_P_TODATEB", sdate },
    //        {"nvar_P_TODATEE", edate }

    //    };
    //    var list = userService.GetUserList_A(param);
    //    int listCount = 0;

    //    if ((list != null) && (list.Count > 0)) 
    //    {
    //        listCount = list.FirstOrDefault().TotalCount;
    //    }

    //    //ucListPager.TotalRecordCount = listCount;
    //  //  lvMemberList.DataSource = list;
    //   // lvMemberList.DataBind();
    //}

    #endregion

    #region <<이벤트>>
    
    protected void ucListPager_PageIndexChange(object sender)
    {
        //UserListBind(ucListPager.CurrentPageIndex);
    }

    #endregion



    //protected void ibtnSearch_Click(object sender, ImageClickEventArgs e)
    //{

    //    UserListBind();      
    //  //  ucListPager.CurrentPageIndex = 1;
    //}
}