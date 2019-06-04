using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Company;
using Urian.Core;

public partial class Admin_Company_CompanyLinkManagement : AdminPageBase
{
    protected string Ucode;
    protected SocialComanyLinkService LinkCompanyService = new SocialComanyLinkService();

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

        Ucode = Request.QueryString["ucode"].ToString();
    }

    #endregion

    #region <<데이터 바인드>>

    protected void DefaultDataBind()
    {
        GetCompanyLinkList();
    }

    protected void GetCompanyLinkList(int page = 1)
    {
        var procParam = new Dictionary<string, object>{
            {"nvar_P_SEARCHTARGET", "NAME" },
            {"nvar_P_SEARCHKEYWORD", txtSearchLinkName.Text.Trim() },
            {"inte_P_PAGENO", page },
            {"inte_P_PAGESIZE", 20 },
        };

        int listCount = 0;

        var list = LinkCompanyService.GetSocialCompanyLinkList(procParam); //부서별 배송지 리스트를 갖고옴
        if (list != null && list.Count > 0)
        {
            listCount = list.FirstOrDefault().TotalCount;
        }
        ucListPager.TotalRecordCount = listCount;
        lvCompanyLinkList.DataSource = list;
        lvCompanyLinkList.DataBind();
    }

    #endregion

    #region <<이벤트>>
    protected void ucListPager_PageIndexChange(object sender)
    {
        GetCompanyLinkList(ucListPager.CurrentPageIndex);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        GetCompanyLinkList();
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {

    }

    protected void lvCompanyLinkList_ItemCommand(object sender, ListViewCommandEventArgs e)
    {
        if (e.CommandName == "Delete")
        {
            var code = e.CommandArgument.AsText();  //svid delivery 를 갖고온다

            var paramList = new Dictionary<string, object> {
                 { "nvar_P_SOCIALCOMPANYLINK_CODE",code}
             };

            LinkCompanyService.DeleteSocialCompanyLink(paramList);
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('삭제되었습니다.');</script>");
            GetCompanyLinkList();
        }
    }

    protected void lvCompanyLinkList_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {

    }
    #endregion

   
    protected void click_save(object sender, EventArgs e)
    {
        var hdLinkSeq = Request[this.hdLinkSeq.UniqueID];
        var LinkCode = Request[this.LinkCode.UniqueID];
        var paramList = new Dictionary<string, object>
        {

           {"nvar_P_BUYSOCIALCOMPANY_CODE",BuyComCode.Text.Trim()},          //구매사 코드
           {"inte_P_BEFORELINKSEQ",hdLinkSeq},           //수정 전 연동순서          
           {"nvar_P_AFTERLINKSEQ",LinkSeq.Text.Trim()},//수정후 연동순서
           {"nvar_P_SOCIALCOMPANYLINK_NAME",ComName.Text.Trim()},          //관계사명
           {"nvar_P_SALESOCIALCOMPANY_CODE",SaleComCode.Text.Trim()},          //판매사명
           {"nvar_P_SOCIALCOMPANYLINK_CODE",LinkCode},          //관계사 연동 코드
           {"nvar_P_REMARK",Remark.Text.Trim()}        //비고
        };
        LinkCompanyService.LinkSeq_Update(paramList);
        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('저장되었습니다.');</script>");
        Response.Redirect(string.Format("CompanyLinkManagement.aspx?")); //메인으로 가기.

    }
    protected void ibtnSave_Click(object sender, EventArgs e)
    {
        var txtSeq = Request[this.txtSeq.UniqueID];
        var tstSdate = Request[this.txtSearchSdate.UniqueID];
        var txtEdate = Request[this.txtSearchEdate.UniqueID];

        var procParam = new Dictionary<string, object>{
            {"nvar_P_SOCIALCOMPANYLINK_CODE", hfLinkCode.Value.Trim() },        //회사연동코드
            {"nvar_P_SOCIALCOMPANYLINK_NAME", txtLinkName.Text.Trim()  },       //회사연동명
            {"nvar_P_SALESOCIALCOMPANY_CODE", hfSaleCompCode.Value.Trim() },    //판매사 구분코드
            {"nvar_P_BUYSOCIALCOMPANY_CODE", hfBuyCompCode.Value.Trim() },      //구매사 구분코드
            {"inte_P_SOCIALCOMPANYLINKSEQ", txtSeq},           //구매사 구분코드
            {"nvar_P_SOCIALCOMPANYLINKBEGINDATE", tstSdate},      //구매사 구분코드
            {"nvar_P_SOCIALCOMPANYLINKENDDATE", txtEdate},      //구매사 구분코드
            {"nvar_P_REMARK", txtRemark.Text.Trim() },                          //비고
        };

        LinkCompanyService.SaveSocialCompanyLink(procParam); //부서별 배송지 리스트를 갖고옴

        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('저장되었습니다.');</script>");

        GetCompanyLinkList();
    }
}