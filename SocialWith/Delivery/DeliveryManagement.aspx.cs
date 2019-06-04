using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Urian.Core;
using SocialWith.Data.Delivery;

public partial class Delivery_DeliveryManagement : PageBase
{
    protected SocialWith.Biz.User.UserService UserService = new SocialWith.Biz.User.UserService();
    protected SocialWith.Biz.Delivery.DeliveryService DeliveryService = new SocialWith.Biz.Delivery.DeliveryService();
    public string Svid = string.Empty;
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
        ParseRequestParameters();
        if (IsPostBack == false)
        {
            DefaultDataBind();
        }
    }

    protected void ParseRequestParameters()
    {
        Svid = Request.QueryString["SvidUser"].ToString();
        Gubun = Request.QueryString["Gubun"].ToString();
    }

    protected void DefaultDataBind()
    {
        GetDeliveryList();
    }

    protected void GetDeliveryList()
    {

        //데이터 컬럼 visible 처리 위해 권한을 조건으로 전역변수에 setting
        switch (Gubun.AsInt())
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
            {"nvar_P_SVID_USER", Svid},
        };

        var list = DeliveryService.GetDeliveryList(listParam); //부서별 배송지 리스트를 갖고옴

        lvDeliveryList.DataSource = list;
        lvDeliveryList.DataBind();
    }

    protected void lvDeliveryList_ItemDataBound(object sender, ListViewItemEventArgs e)
    {
       
        if (e.Item.ItemType == ListViewItemType.DataItem)         //구분값에 따른 컬럼 헤더 visible처리
        {
            Control tdHeaderArea = lvDeliveryList.FindControl("tdHeaderArea");
            Control tdHeaderBusiness = lvDeliveryList.FindControl("tdHeaderBusiness");
            ListViewDataItem dataItem = (ListViewDataItem)e.Item;

            if (tdHeaderBusiness != null && tdHeaderArea != null)
            {
                tdHeaderArea.Visible = !AreaViewFlag ? false : true;
                tdHeaderBusiness.Visible = !BusinessViewFlag ? false : true;
            }

            if (e.Item.DataItemIndex > 0)
            {
                ImageButton addDelivery = (ImageButton)dataItem.FindControl("addDelivery");
                if (addDelivery != null)
                {
                    addDelivery.Visible = false;
                }
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

    //protected void btnAdd_Click(object sender, ImageClickEventArgs e)
    //{
    //    var createSvidDelivery = Guid.NewGuid().ToString();
    //    var paramList = new Dictionary<string, object> {
    //            { "nvar_P_SVID_DELIVERY",createSvidDelivery}
    //            ,{ "nvar_P_SVID_USER",Svid}
    //            ,{ "nvar_P_COMPANY_NO",hfCompNo.Value.Trim()}
    //            ,{ "nvar_P_COMPANY_CODE",hfCompCode.Value.Trim()}
    //            ,{ "nvar_P_COMPANYAREA_CODE",hfAreaCode.Value.Trim()}
    //            ,{ "nvar_P_COMPBUSINESSDEPT_CODE",hfBusinessCode.Value.Trim()}
    //            ,{ "nvar_P_COMPANYDEPT_CODE",hfDeptCode.Value.Trim()}
    //            ,{ "nvar_P_DELIVERY_DEFAULT","N"}
    //            ,{ "nvar_P_DELIVERY_NOSUB",""}
    //            ,{ "nvar_P_DELIVERY_PERSON",hfPerson.Value.Trim()}
    //            ,{ "nvar_P_DELIVERY_DELFLAG","N"}
    //            ,{ "nvar_P_ZIPCODE",hfPostalCode.Value.Trim()}
    //            ,{ "nvar_P_ADDRESS_1",hfAddress1.Value.Trim()}
    //            ,{ "nvar_P_ADDRESS_2",txtAddress2.Text.Trim()}
    //        };

    //    DeliveryService.SaveDelivery(paramList);
    //    GetDeliveryList();
    //}
    protected void btnDefaultUpdate_Click(object sender, ImageClickEventArgs e)
    {
        foreach (ListViewItem item in lvDeliveryList.Items)
        {
            CheckBox chDefault = (CheckBox)item.FindControl("chDefault");
            HiddenField hfListSvidDelivery = (HiddenField)item.FindControl("hfListSvidDelivery");
            HiddenField hfListSvidUser = (HiddenField)item.FindControl("hfListSvidUser");
            HiddenField hfListCompCode = (HiddenField)item.FindControl("hfListCompCode");
            HiddenField hfListCompAreaCode = (HiddenField)item.FindControl("hfListCompAreaCode");
            HiddenField hfListCompBusinessCode = (HiddenField)item.FindControl("hfListCompBusinessCode");
            HiddenField hfListCompDeptCode = (HiddenField)item.FindControl("hfListCompDeptCode");

            if (chDefault.Checked)
            {
                var paramList = new Dictionary<string, object> {
                     { "nvar_P_SVID_DELIVERY",hfListSvidDelivery.Value.Trim()}
                    ,{ "nvar_P_SVID_USER",hfListSvidUser.Value.Trim()}
                    ,{ "nvar_P_COMPANY_CODE",hfListCompCode.Value.Trim()}
                    ,{ "nvar_P_COMPANYAREA_CODE",hfListCompAreaCode.Value.Trim()}
                    ,{ "nvar_P_COMPBUSINESSDEPT_CODE",hfListCompBusinessCode.Value.Trim()}
                    ,{ "nvar_P_COMPANYDEPT_CODE",hfListCompDeptCode.Value.Trim()}

                    };

                DeliveryService.UpdateDeliveryDefault(paramList);
            }
        }
        Response.Redirect("DeliveryList.aspx");
    }

    protected void lvDeliveryList_ItemCommand(object sender, ListViewCommandEventArgs e)
    {
        if (e.CommandName == "Delete")
        {
            var svidDelivery = e.CommandArgument.AsText();  //svid delivery 를 갖고온다

            var paramList = new Dictionary<string, object> {
                 { "nvar_P_SVID_DELIVERY",svidDelivery}
             };

            DeliveryService.DeleteDelivery(paramList);
            GetDeliveryList();
        }
    }

    //listview Row Delete 이벤트를 위해 
    protected void lvDeliveryList_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {

    }







    protected void btnDefaultUpdate_Click(object sender, EventArgs e)
    {
        foreach (ListViewItem item in lvDeliveryList.Items)
        {
            CheckBox chDefault = (CheckBox)item.FindControl("chDefault");
            HiddenField hfListSvidDelivery = (HiddenField)item.FindControl("hfListSvidDelivery");
            HiddenField hfListSvidUser = (HiddenField)item.FindControl("hfListSvidUser");
            HiddenField hfListCompCode = (HiddenField)item.FindControl("hfListCompCode");
            HiddenField hfListCompAreaCode = (HiddenField)item.FindControl("hfListCompAreaCode");
            HiddenField hfListCompBusinessCode = (HiddenField)item.FindControl("hfListCompBusinessCode");
            HiddenField hfListCompDeptCode = (HiddenField)item.FindControl("hfListCompDeptCode");

            if (chDefault.Checked)
            {
                var paramList = new Dictionary<string, object> {
                     { "nvar_P_SVID_DELIVERY",hfListSvidDelivery.Value.Trim()}
                    ,{ "nvar_P_SVID_USER",hfListSvidUser.Value.Trim()}
                    ,{ "nvar_P_COMPANY_CODE",hfListCompCode.Value.Trim()}
                    ,{ "nvar_P_COMPANYAREA_CODE",hfListCompAreaCode.Value.Trim()}
                    ,{ "nvar_P_COMPBUSINESSDEPT_CODE",hfListCompBusinessCode.Value.Trim()}
                    ,{ "nvar_P_COMPANYDEPT_CODE",hfListCompDeptCode.Value.Trim()}

                    };

                DeliveryService.UpdateDeliveryDefault(paramList);
            }
        }
        Response.Redirect("DeliveryList.aspx");
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        var createSvidDelivery = Guid.NewGuid().ToString();
        var paramList = new Dictionary<string, object> {
                { "nvar_P_SVID_DELIVERY",createSvidDelivery}
                ,{ "nvar_P_SVID_USER",Svid}
                ,{ "nvar_P_COMPANY_NO",hfCompNo.Value.Trim()}
                ,{ "nvar_P_COMPANY_CODE",hfCompCode.Value.Trim()}
                ,{ "nvar_P_COMPANYAREA_CODE",hfAreaCode.Value.Trim()}
                ,{ "nvar_P_COMPBUSINESSDEPT_CODE",hfBusinessCode.Value.Trim()}
                ,{ "nvar_P_COMPANYDEPT_CODE",hfDeptCode.Value.Trim()}
                ,{ "nvar_P_DELIVERY_DEFAULT","N"}
                ,{ "nvar_P_DELIVERY_NOSUB",""}
                ,{ "nvar_P_DELIVERY_PERSON",hfPerson.Value.Trim()}
                ,{ "nvar_P_DELIVERY_DELFLAG","N"}
                ,{ "nvar_P_ZIPCODE",hfPostalCode.Value.Trim()}
                ,{ "nvar_P_ADDRESS_1",hfAddress1.Value.Trim()}
                ,{ "nvar_P_ADDRESS_2",txtAddress2.Text.Trim()}
            };

        DeliveryService.SaveDelivery(paramList);
        GetDeliveryList();
    }
}