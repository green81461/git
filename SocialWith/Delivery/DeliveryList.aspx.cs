using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Urian.Core;
using SocialWith.Data.Delivery;

public partial class Delivery_DeliveryList : PageBase
{
    protected SocialWith.Biz.User.UserService UserService = new SocialWith.Biz.User.UserService();
    protected SocialWith.Biz.Delivery.DeliveryService DeliveryService = new SocialWith.Biz.Delivery.DeliveryService();
    public string Gubun = string.Empty;
    public bool AreaViewFlag = false;
    public bool BusinessViewFlag = false;
    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack == false)
        {
            DefaultDataBind();
        }
    }


    protected void DefaultDataBind() {

        GetUserInfo();
        GetDeliveryDeptList();
    }

    protected void GetUserInfo() {
        var paramList = new Dictionary<string, object>{
            {"nvar_P_ID",UserId},
        };

        var userInfo = UserService.GetDeliveryUserInfo(paramList);
        if (userInfo != null && userInfo.UserInfo != null)
        {
            lblComanyName.Text = userInfo.UserInfo.Company_Name.Trim();
            lblUserId.Text = userInfo.Id.Trim();
        }
    }

    protected void GetDeliveryDeptList() {
        var infoParam = new Dictionary<string, object>{
            {"nvar_P_SVID_USER",Svid_User},
        };
        var deliveryNo = DeliveryService.GetDeliveryNo(infoParam); //딜리버리 구분을 갖고옴

        
        List<DeliveryDeptDTO> list = null;
        if (deliveryNo != 0)
        {
            Gubun = deliveryNo.AsText();
            //데이터 컬럼 visible 처리 위해 권한을 조건으로 전역변수에 setting
            switch (deliveryNo)
            {
                //case 1:
                //    AreaViewFlag = true;
                //    BusinessViewFlag = true;
                //    break;
                //case 2:
                //    AreaViewFlag = true;
                //    BusinessViewFlag = true;
                //    break;
                case 3:
                    AreaViewFlag = false;
                    BusinessViewFlag = true;
                    break;
                case 4:
                    AreaViewFlag = false;
                    BusinessViewFlag = false;
                    break;
                default:
                    break;
            }

            var listParam = new Dictionary<string, object>{
            {"nvar_P_ID",UserId},
            {"nvar_P_RESULT",deliveryNo.AsText()},
        };

            list = DeliveryService.GetDeliveryListByDept(listParam); //부서별 배송지 리스트를 갖고옴
        }

        lvDeliveryList.DataSource = list;
        lvDeliveryList.DataBind();
    }

    protected void lvDeliveryList_ItemDataBound(object sender, ListViewItemEventArgs e)
    {
        if (e.Item.ItemType == ListViewItemType.DataItem)         //구분값에 따른 컬럼 헤더 visible처리
        {
            Control tdHeaderArea = lvDeliveryList.FindControl("tdHeaderArea");
            Control tdHeaderBusiness = lvDeliveryList.FindControl("tdHeaderBusiness");
           

            if (tdHeaderBusiness != null && tdHeaderArea != null)
            {
                tdHeaderArea.Visible = !AreaViewFlag ? false : true;
                tdHeaderBusiness.Visible = !BusinessViewFlag ? false : true;
             }
        }

       
        if (e.Item.ItemType == ListViewItemType.EmptyItem)
        {

            Control tdEmptyArea = lvDeliveryList.FindControl("tdEmptyArea");  //구분값에 따른 empty컬럼 헤더 visible처리
            Control tdEmptyBusiness = lvDeliveryList.FindControl("tdEmptyBusiness");
            if (tdEmptyArea != null && tdEmptyBusiness != null)
            {
                tdEmptyArea.Visible = !AreaViewFlag ? false : true;
                tdEmptyBusiness.Visible = !BusinessViewFlag ? false : true;
            }
        }
    }
}