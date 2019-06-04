using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Comapny;
using Urian.Core;

public partial class Admin_Company_BorderTypeRegister : AdminPageBase
{
    protected string Ucode;
    CompanyService companyService = new CompanyService();
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
    }
    protected void ParseRequestParameters()
    {

        //  Svid = Request.QueryString["Svid"].ToString();
        Ucode = Request.QueryString["ucode"].ToString();
    }


    protected bool CodeDuplicationCheck()
    {

        bool isDupl = false;
        var paramList = new Dictionary<string, object>
        {
           {"nvar_P_URIANBORDERTCODE", txtCode.Text.Trim() },
        };
        string returnValue = companyService.BorderTypeDuplicationCheck(paramList);

        if (!string.IsNullOrWhiteSpace(returnValue))
        {
            isDupl = true;
        }
        return isDupl;
    }

    protected void ibSave_Click(object sender, EventArgs e)
    {

        var duplCheck = CodeDuplicationCheck();

        if (duplCheck)
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('중복된 코드가 있습니다.');</script>");

            txtCode.Text = string.Empty;
        }
        else
        {
            var paramList = new Dictionary<string, object>
        {
           {"nvar_P_URIANBORDERTCODE", txtCode.Text.Trim() },
           {"nvar_P_URIANBORDERTNAME",txtName.Text.Trim() },
           {"nvar_P_SVID_USER",Svid_User },
           {"nvar_P_REMARK",txtRemark.Text.Trim() }
        };
            companyService.SaveBorderType(paramList);
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('저장되었습니다.');</script>");
        }
    }
}