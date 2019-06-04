using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Comm;
using SocialWith.Biz.ReturnChange;
using Urian.Core;

public partial class Admin_BalanceAccounts_ReturnList : AdminPageBase
{
    CommService commService = new CommService();
    ReturnChangeService rgServive = new ReturnChangeService();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DefaultDataBind(); // 소스 임시로 AdminSub 에 있는 내용 복붙
        } 
    }

    #region <<데이터바인드>>
    protected void DefaultDataBind()
    {
        txtSearchEdate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        txtSearchSdate.Text = DateTime.Now.AddDays(-7).ToString("yyyy-MM-dd");
        OrderStatusDataBind();
    }

    protected void OrderStatusDataBind()
    {

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPCODE", "PAY"},
            { "nume_P_MAPCHANEL", 3},
        };

        var list = commService.GetCommList(paramList);

        if (list != null)
        {
            if (list.Count > 0)
            {
                foreach (var item in list)
                {
                    if (item.Map_Type != 0)
                    {
                        ddlReturnStatus.Items.Add(new ListItem(item.Map_Name, item.Map_Type.AsText()));
                    }
                }
            }
        }
    }

    //protected void GetReturnList(int page = 1)
    //{

    //    var procParam = new Dictionary<string, object>{

    //        {"nvar_P_SVID_USER", Svid_User},
    //        {"nvar_P_TODATEB",  txtSearchSdate.Text },
    //        {"nvar_P_TODATEE", txtSearchEdate.Text },
    //        {"nvar_P_ORDERSTATUS", ddlReturnStatus.SelectedValue },
    //        {"nvar_P_BUYCOMPANY", txtBuySaleName.Value.Trim() },
    //        {"nume_P_PAGENO", page },
    //        {"nume_P_PAGESIZE", 20 },

    //    };

    //    int listCount = 0;

    //    var list = rgServive.GetAdminSubReturnList(procParam);


    //    if (list != null)
    //    {
    //        if (list.Count > 0)
    //        {
    //            list.ToList().ForEach(s => s.GoodsInfo = "[" + s.BrandName + "]" + s.GoodsFinalName + "<br/>" + s.GoodsOptionSummaryValues);
    //            listCount = list.FirstOrDefault().TotalCount;

    //        }
    //    }

    //    ucListPager.TotalRecordCount = listCount;
    //    lvReturnList.DataSource = list;
    //    lvReturnList.DataBind();
    //}
    #endregion

    #region <<이벤트>>


    protected void imgSearch_Click(object sender, ImageClickEventArgs e)
    {
        //GetReturnList(1);
        //ucListPager.CurrentPageIndex = 1;
    }


    // 엑셀저장
    protected void btnRtnExcel_Click(object sender, ImageClickEventArgs e)
    {
        //var paramList = new Dictionary<string, object>
        //{
        //    {"nvar_P_SVID_USER",  Svid_User },
        //    {"nvar_P_TODATEB",  txtSearchSdate.Text },
        //    {"nvar_P_TODATEE", txtSearchEdate.Text },
        //    {"nvar_P_ORDERSTATUS", ddlReturnStatus.SelectedValue },
        //    {"nvar_P_BUYCOMPNAME", txtBuySaleName.Value.Trim() }
        //};


        //var list = rgServive.GetAdminSubExcelReturnList(paramList);

        //if ((list != null) && (list.Count > 0))
        //{
        //    for (int i = 0; i < list.Count; i++)
        //    {
        //        var gdsSalePriceVat = Int32.Parse(list[i].GoodsSalePriceVat.AsText());
        //        var totGdsSalePriceVat = Int32.Parse(list[i].GoodsTotalSalePriceVat.AsText());
        //        var rtnPrice = Int32.Parse(list[i].ReturnChangePrice.AsText());

        //        list[i].GoodsSalePriceVat = string.Format("{0:#,###}", gdsSalePriceVat).AsText();
        //        list[i].GoodsTotalSalePriceVat = string.Format("{0:#,###}", totGdsSalePriceVat).AsText();
        //        list[i].ReturnChangePrice = string.Format("{0:#,###}", rtnPrice).AsText();
        //    }
        //}

        //var fileName = Server.UrlEncode(AdminId + "_반품내역");
        //ExeclExport.ExportExcel(fileName, "xlsx", list);
    }
    #endregion
}