using System;
using System.Collections.Generic;
using System.Web.UI;
using SocialWith.Biz.Goods;
using Urian.Core;
using SocialWith.Biz.Category;


public partial class Admin_Goods_SupplierRegister : AdminPageBase
{
    protected CategoryService categoryService = new CategoryService();
    GoodsService GoodsService = new GoodsService();
    protected string Ucode;
    string companycode;
    string tellno;
    string phoneno;
    string faxno;
    string email;
    string Paydate;

    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();

        if (IsPostBack == false)
        {
            DefaultDataBind();
            ibCodeCreate_Click();

        }
    }

    protected void ParseRequestParameters()
    {
        Ucode = Request.QueryString["ucode"].ToString();
    }

    protected void DefaultDataBind()
    {
        SupplyDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

    }

    protected void ibCodeCreate_Click()
    {

        var paramList = new Dictionary<string, object>
        {

        };
        string lastCode = GoodsService.GetComCodeNo(paramList);

        if ((lastCode == null) || (lastCode == ""))  //값이 있으면 false
        {
            hfComCodeNo.Value = ComCodeNo.Text = "SC00001";
        }

        else
        {
            string firstCh = lastCode.Substring(0, 2).AsText("SC");
            string currentCodeExNo = lastCode.Substring(2, 5).AsText("00000");

            string nextCodeExNo = (currentCodeExNo.AsInt() + 1).ToString("00000");

            hfComCodeNo.Value = ComCodeNo.Text = firstCh + nextCodeExNo;

        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        String bankName = string.Empty;
        String bankNo = string.Empty;
        String SupplyBankName = string.Empty;

        if (ddlTelPhone.SelectedValue == "0")
        {
            tellno = lblMiddleNumber.Text + "-" + lblLastNumber.Text;
            
        }
        else
        {
            tellno = ddlTelPhone.SelectedValue + "-" + lblMiddleNumber.Text + "-" + lblLastNumber.Text;
            bankName = txtBankName.Text;
            bankNo = txtBankNo.Text;
            SupplyBankName = txtSupplyBankName.Text;
        }

        phoneno = ((string.IsNullOrWhiteSpace(txtSelPhone2.Text) && string.IsNullOrWhiteSpace(txtSelPhone3.Text)) == true ? "" : ddlSelPhone.Text + "-" + txtSelPhone2.Text + "-" + txtSelPhone3.Text);
        faxno = ((string.IsNullOrWhiteSpace(lblMiddleFax.Text) && string.IsNullOrWhiteSpace(lblLastFax.Text)) == true ? "" : ddlFax.Text + "-" + lblMiddleFax.Text + "-" + lblLastFax.Text);
        email = ((string.IsNullOrWhiteSpace(txtFirstEmail.Text) && string.IsNullOrWhiteSpace(txtLastEmail.Text)) == true ? "" : txtFirstEmail.Text + "@" + txtLastEmail.Text);
        companycode = lblFirstNum.Text + "-" + lblMiddleNum.Text + "-" + lblLastNum.Text;

        var paramList = new Dictionary<string, object>
        {
           {"nvar_P_SUPPLYCOMPANYCODE", hfComCodeNo.Value.Trim() },
           {"nvar_P_SUPPLYCOMPANYNAME",txtComName.Text.Trim() },
           {"nvar_P_SUPPLYCOMPANY_NO",companycode.Trim() },
           {"nvar_P_SUPPLYCOMPANYDELEGATE_NAME",lblName.Text.Trim() },
           {"nvar_P_TELNO",tellno.Trim() },
           {"nvar_P_PHONENO",phoneno.Trim() },
           {"nvar_P_FAXNO",faxno.Trim() },
           {"nvar_P_EMAIL",email.Trim() },
           {"char_P_ZIPCODE",hfPostalCode.Value.Trim() },
           {"nvar_P_ADDRESS_1",hfAddress1.Value.Trim() },
           {"nvar_P_ADDRESS_2",txtAddress2.Text.Trim() },
           {"nvar_P_NAME",txtPerson.Text.Trim() },
           {"nvar_P_DEPTNAME",lblDept.Text.Trim() },
           {"nvar_P_SUPPLYDATE", String.Format("{0:yyyy-MM-dd}",  SupplyDate.Text)},
           {"nvar_P_PAYDATE", PayDate.Text.Trim()},                //결제일자( DD )
           {"nvar_P_SUPPLYCATEGORY",categoryCode.Value.Trim()},    //카테고리명
           {"nvar_P_ADMINUSERID",hfAdmUserId.Value.Trim()},        //우리안담당자코드
           {"nvar_P_ADMINUSERNAME",hfAdmUserNm.Value.Trim()},       //우리안담당자명
           {"nvar_P_BANKNAME",bankName.Trim()},
           {"nvar_P_BANKNO",bankNo.Trim()},
            {"nvar_P_SUPPLYBANKNAME",SupplyBankName.Trim()}
        };

        GoodsService.SaveCompany(paramList);
        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('저장되었습니다.');</script>");
        Response.Redirect(string.Format("SupplierMain.aspx?ucode=" + Ucode)); //메인으로 가기.
    }
}