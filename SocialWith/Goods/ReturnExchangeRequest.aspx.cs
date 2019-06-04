using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;

public partial class Goods_ReturnExchangeRequest : PageBase
{
    protected SocialWith.Biz.Order.OrderService orderService = new SocialWith.Biz.Order.OrderService();
    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack == false)
        {
            OrderEndListBind();
        }
    }

    #region << 배송완료된 목록 조회 - 데이터바인드 >>
    protected void OrderEndListBind(int page = 1)
    {
        var paramList = new Dictionary<string, object>{
              {"nvar_P_SVID_USER",Svid_User}
            , {"nume_P_PAGENO",page}
            , {"nume_P_PAGESIZE",20}
            , {"nvar_P_SERACHTARGET",ddlSearchTarget.SelectedValue}
            , {"nvar_P_SEARCHKEYWORD",txtSearch.Text.AsText()}
        };

        var list = orderService.GetOrderEndList(paramList);
        int listCount = 0;

        if ((list != null) && (list.Count > 0))
        {
            listCount = list.FirstOrDefault().TotalCount;
        }

        ucListPager.TotalRecordCount = listCount;
        lvRequestList.DataSource = list;
        lvRequestList.DataBind();
    }
    #endregion

    protected void ucListPager_PageIndexChange(object sender)
    {
        OrderEndListBind(ucListPager.CurrentPageIndex);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        OrderEndListBind();
    }

    protected int Calculate(int a, int b)
    {

        int returnVal = (a * b);
        return returnVal;
    }
    
}