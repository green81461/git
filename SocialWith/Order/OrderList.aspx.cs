using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Order;
using SocialWith.Data.GoodsLoan;
using Urian.Core;
using System.Web.UI.HtmlControls;

public partial class Order_OrderList : PageBase
{
    OrderService OrderService = new OrderService();
    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        orderCss.Text = string.Format("<link rel=\"stylesheet\" type=\"text/css\" href=\"{0}\"></script>", "../Content/Order/order.css?dt=" + DateTime.Now.ToString("yyyyMMddhhmmss"));
        if (IsPostBack == false)
        {
            DefaultDataBind();
        }
    }

    #region <<데이터바인드>>
    protected void DefaultDataBind()
    {
        string compcode = string.Empty;
        string saleCompCode = string.Empty;
        string freeCompYN = string.Empty;
  
        if (UserInfoObject != null && UserInfoObject.UserInfo != null)
        {
            compcode = !string.IsNullOrWhiteSpace(UserInfoObject.UserInfo.PriceCompCode) ? UserInfoObject.UserInfo.PriceCompCode : "EMPTY";
            saleCompCode = !string.IsNullOrWhiteSpace(UserInfoObject.UserInfo.SaleCompCode) ? UserInfoObject.UserInfo.SaleCompCode : "EMPTY";
            freeCompYN = UserInfoObject.UserInfo.FreeCompanyYN.AsText("N");
        }
        //리스트 받아오는거..
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", Svid_User },
            {"nvar_P_COMPCODE", compcode },
            {"nvar_P_SALECOMPCOE", saleCompCode },
            {"nvar_P_BDONGSHINCHECK", UserInfoObject.UserInfo.BmroCheck.AsText("N")},
            {"nvar_P_FREECOMPANYYN", freeCompYN},
        };

        var list = OrderService.GetOrderTryList(paramList);

        rptOrder.DataSource = list;
        rptOrder.DataBind();
        
    }

    protected string SetGoodsDisplayText(string goodsYN, string reason)
    {
        string returnVal = string.Empty;
        if (goodsYN == "N")
        {
            returnVal = "(판매 개시전)";
        }
        else if (goodsYN == "Y")
        {
            if (!string.IsNullOrWhiteSpace(reason))
            {
                returnVal = "(" + reason + ")";
            }
        }
        return returnVal;
    }


    #endregion

    protected void rptOrder_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (rptOrder.Items.Count == 0)
        {
            if (e.Item.ItemType == ListItemType.Footer)
            {
                HtmlTableRow lblFooter = (HtmlTableRow)e.Item.FindControl("trEmpty");
                lblFooter.Visible = true;
            }
        }

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            //면세상품이면 글자 출력
            var taxYn = ((HiddenField)e.Item.FindControl("hfGdsTax")).Value.AsText();
            if (taxYn.Equals("2"))
                e.Item.FindControl("lblTax").Visible = true;
            
            var paramList = new Dictionary<string, object> {
                {"nvar_P_SVID_USER", Svid_User }
            };

            var goodsLoanInfo = OrderService.GetGoodsLoanInfo(paramList);
            if (goodsLoanInfo != null)
            {
                if (goodsLoanInfo.DelFlag.Equals("Y") || goodsLoanInfo.DelFlag.Equals("A"))
                    hfRemainPrice.Value = goodsLoanInfo.RemainPrice.AsText();
            }
        }
    }
}