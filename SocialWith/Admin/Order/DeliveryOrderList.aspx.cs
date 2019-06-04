﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Comm;
using Urian.Core;

public partial class Admin_Order_DeliveryOrderList : AdminPageBase
{

    CommService commService = new CommService();

    protected void Page_Load(object sender, EventArgs e)
    {
        DefaultDataBind();
    }

    protected void DefaultDataBind()
    {
        txtSearchSdate.Text = DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd");
        txtSearchEdate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        OrderStatusDataBind();
        PayWayDataBind();
    }

    protected void OrderStatusDataBind()
    {
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPCODE", "ORDER"},
            { "nume_P_MAPCHANEL", 2},
        };

        var list = commService.GetCommList(paramList);


        ddlOrderStatus.Items.Add(new ListItem("---전체---", "ALL"));

        if ((list != null) && (list.Count > 0))
        {
            foreach (var item in list)
            {
                if (item.Map_Type != 0 && (item.Map_Type >= 200 && item.Map_Type < 400))
                {
                    // ddlOrderStatus.Items.Add(new ListItem(item.Map_Name, item.Map_Channel + "_" + item.Map_Type));
                    ddlOrderStatus.Items.Add(new ListItem(item.Map_Name, item.Map_Type.AsText()));
                }
            }
        }
    }


    protected void PayWayDataBind()
    {
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPCODE", "PAY"},
            { "nume_P_MAPCHANEL", 3},
        };

        var list = commService.GetCommList(paramList);

        ddlPayWay.Items.Add(new ListItem("---전체---", "ALL"));
        if ((list != null) && (list.Count > 0))
        {
            foreach (var item in list)
            {
                if (item.Map_Type != 0)
                {

                    ddlPayWay.Items.Add(new ListItem(item.Map_Name, item.Map_Type.AsText()));
                }
            }
        }
    }
}