using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;
using SocialWith.Biz.User;

public partial class Order_OrderNoPassbookResult : PageBase
{
    protected string GoodsName;
    protected string OrderCodeNo;
    protected string BuyerName;
    protected string BuyerComName;
    protected decimal Amt;
    protected string SaleComName;
    protected string BuyerTel;
    protected string BuyerEmail;
    protected string Payway;
    protected string SubjectDate;
    

    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            DefaultDataBind();
        }
    }

    #region << 데이터 바인드 >>
    protected void DefaultDataBind()
    {
        OrderCodeNo = Request.Form["txtOrdCodeNo"].AsText();
        GoodsName = Request.Form["txtGoodsName"].AsText();
        Amt = Request.Form["hdAmt"].AsDecimal();
        BuyerName = Request.Form["txtBuyerName"].AsText();
        BuyerTel = Request.Form["txtBuyerTel"].AsText();
        BuyerEmail = Request.Form["txtBuyerEmail"].AsText();
        SaleComName = Request.Form["hdSaleComName"].AsText();
        BuyerComName = Request.Form["hdBuyerComName"].AsText();
        

        var useSMS = ConfigurationManager.AppSettings["SendSMSUse"].AsText("false");
        if (useSMS == "true")
        {
            SendMMS();
        }
    }

    private void SendMMS()
    {

        UserService UserService = new UserService();
        var paramList = new Dictionary<string, object>
    {
        {"nvar_P_TYPE", "ORDER"},
    };

        var list = UserService.GetSMSUserList(paramList);

        if (list != null)
        {
            string incomingUser = string.Empty;

            foreach (var item in list)
            {
                incomingUser += item.Name + "^" + Crypt.AESDecrypt256(item.PhoneNo).Replace("-", "") + "|";
            }

            if (!string.IsNullOrWhiteSpace(incomingUser))
            {
                var paramList2 = new Dictionary<string, object>
            {
                 {"nvar_P_SUBJECT", "[상품 주문 접수]"},
                {"nvar_P_DEST_INFO", incomingUser.Substring(0, incomingUser.Length-1)},
                {"nvar_P_MSG",  "[상품 주문 접수]\r\n주문번호 : "+ OrderCodeNo+"\r\n회사명 : "+ BuyerComName +"\r\n금액 : " + Amt.ToString("N0") + "원" + "\r\n주문 검토 후 발송 진행해주시기 바랍니다."},
            };

                UserService.OrderMMSInsert(paramList2);
            }

        }
    }
    #endregion

}