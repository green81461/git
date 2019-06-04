using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Web.UI;
using SocialWith.Biz.Category;
using Urian.Core;

public partial class Admin_Goods_CategoryRegister : AdminPageBase
{
    protected CategoryService categoryService = new CategoryService();
    protected string Ucode;
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
    }

    protected void ParseRequestParameters()
    {
        Ucode = Request.QueryString["ucode"].ToString();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        //string CategoryFinalCode = Request.Params["hdFinalCode"].ToString();
        //string CategoryFinalName = Request.Params["hdFinalName"].ToString();
        //string CategoryLevelCode = Request.Params["hdLevelCode"].ToString();
        //string CategoryUpCode = Request.Params["hdGroupCode"].ToString();

        string strCategoryNo = Regex.Replace(hdfFinalCode.Value, @"\D", "");

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_CATEGORYFINALCODE", hdfFinalCode.Value},
            {"nvar_P_CATEGORYFINALNAME",hdfFinalName.Value},
            {"nvar_P_CATEGORYLEVELCODE",hdfLevelCode.Value},
            {"nvar_P_CATEGORYUPCODE",hdfGroupCode.Value},
            {"nvar_P_CATEGORYNO",strCategoryNo}
        };

        categoryService.CategoryInsert(paramList);
        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('저장되었습니다.');</script>");
        Response.Redirect(string.Format("CategoryManage.aspx?ucode=" + Ucode)); //메인으로 가기.
    }
}
