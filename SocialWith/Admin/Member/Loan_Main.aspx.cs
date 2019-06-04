using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.User;
using SocialWith.Biz.Category;
using SocialWith.Biz.Goods;
public partial class Admin_Member_Loan_Main : AdminPageBase
{
    protected string Ucode;
    GoodsService GoodsService = new GoodsService();
    UserService UserService = new UserService();
    CategoryService categoryService = new CategoryService();
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

        //  Svid = Request.QueryString["Svid"].ToString();
        Ucode = Request.QueryString["ucode"].ToString();
    }
    protected void DefaultDataBind()
    {

        LoanDataBind();
    }

    protected void LoanDataBind(int page = 1)
    {

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHKEYWORD", txtSearch.Text.Trim() },
            {"nvar_P_SERACHTARGET","All" },
            {"inte_P_PAGENO", page },
            {"inte_P_PAGESIZE", 20 },
        };


        var list = UserService.Get_LOAN_List_Admin(paramList);
        int listCount = 0;
        if (list != null)
        {
            if (list.Count > 0)
            {
                listCount = list.FirstOrDefault().TotalCount;
            }
        }

        ucListPager.TotalRecordCount = listCount;
        lvBrandList.DataSource = list;
        lvBrandList.DataBind();
    }

    protected void click_save(object sender, EventArgs e)
    {
        var paramList = new Dictionary<string, object>
        {

           {"nvar_P_BUYCOMNAME",txtMappName.Text.Trim()},          //구매사명
           {"nvar_P_MAPPCOMPANY_CODE",txtMappCode.Text.Trim()},           //구매사코드
           {"nvar_P_BULKBANKNO",txtBulk.Text.Trim()},               //벌크계좌번호
           {"nvar_P_REMARK",txtRemark.Text.Trim()},             //비고
           {"nvar_P_SVID_USER",Svid_User},                       //접속아이디
            {"nvar_P_COMPANY_CODE",txtComCode.Text.Trim() }
        };
        GoodsService.SaveLoanUpdate(paramList);
        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('저장되었습니다.');</script>");
        Response.Redirect(string.Format("Loan_Main.aspx?ucode="+ Ucode)); //메인으로 가기.

    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoanDataBind();
        ucListPager.CurrentPageIndex = 1;
    }
    protected void ucListPager_PageIndexChange(object sender)
    {
        LoanDataBind(ucListPager.CurrentPageIndex);
    }

    protected void lvBrandList_ItemDataBound(object sender, ListViewItemEventArgs e)
    {
        if (e.Item.ItemType == ListViewItemType.DataItem)         //구분값에 따른 컬럼 헤더 visible처리
        {
            ListViewDataItem dataItem = (ListViewDataItem)e.Item;

            ImageButton ibtnBrandDelete = (ImageButton)dataItem.FindControl("ibtnBrandDelete");
            ImageButton ibtnBrandUse = (ImageButton)dataItem.FindControl("ibtnBrandUse");
            HiddenField hfDelFlag = (HiddenField)dataItem.FindControl("hfDelFlag");

            if (ibtnBrandDelete != null && ibtnBrandUse != null && hfDelFlag != null)
            {
                if (hfDelFlag.Value == "N" || string.IsNullOrWhiteSpace(hfDelFlag.Value))
                {
                    ibtnBrandDelete.Visible = true;
                    ibtnBrandUse.Visible = false;
                }
                else
                {
                    ibtnBrandDelete.Visible = false;
                    ibtnBrandUse.Visible = true;
                }
            }
        }
    }






}