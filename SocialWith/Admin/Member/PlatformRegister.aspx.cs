using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Platform;

public partial class Admin_Member_PlatformRegister : AdminPageBase
{
    protected string Ucode;
    PlatformService platformService = new PlatformService();
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
    }
    protected void ParseRequestParameters()
    {
        //  Svid = Request.QueryString["Svid"].ToString();
        Ucode = Request.QueryString["ucode"].ToString();
    }

    protected void ibSave_Click(object sender, ImageClickEventArgs e)
    {
        var duplCheck = CodeDuplicationCheck();

        if (duplCheck)
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('중복된 코드가 있습니다.');</script>");

            txtPlatformCode.Text = string.Empty;
        }
        else
        {
            var paramList = new Dictionary<string, object>
            {
               {"nvar_P_BRANDCODE", txtPlatformCode.Text.Trim() },
               {"nvar_P_BRANDNAME",txtPlatformName.Text.Trim() },
               {"nvar_P_SVID_USER", Svid_User },
               {"nvar_P_REMARK", txtRemark.Text.Trim() }
            };

            platformService.SavePlatform(paramList);
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('저장되었습니다.');</script>");
        }


    }

    protected bool CodeDuplicationCheck()
    {

        bool isDupl = false;
        var paramList = new Dictionary<string, object>
        {
           {"nvar_P_URIANAPLATFORMCODE", txtPlatformCode.Text.Trim() },
        };
        string returnValue = platformService.PlatfomTypeDuplicationCheck(paramList);

        if (!string.IsNullOrWhiteSpace(returnValue))
        {
            isDupl = true;
        }
        return isDupl;
    }
}