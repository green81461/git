using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.User;
using Urian.Core;

public partial class AdminSub_Member_MemberEdit : AdminSubPageBase
{


    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack == false)
        {
            GetUserInfo();
        }
    }

    public void GetUserInfo()
    {

        var service = new UserService();
        var paramList = new Dictionary<string, object>() {
            {"nvar_P_ID",  UserId}
        };

        var user = service.GetUser(paramList);

        if (user != null)
        {
            lblId.Text = user.Id;
            lblOrgName.Text = user.UserInfo.Company_Name;
            string[] compNo = user.UserInfo.Company_No.Split('-');
            lblFirstNum.Text = compNo[0];
            lblMiddleNum.Text = compNo[1];
            lblLastNum.Text = compNo[2];
            lblName.Text = user.UserInfo.Delegate_Name;
            lblFirstAddr.Text = user.UserInfo.ZipCode;
            lblAddr2.Text = user.UserInfo.Address_1;
            lblAddr3.Text = user.UserInfo.Address_2;
            txtPerson.Text = user.Name;
            lblDept.Text = user.UserInfo.CompanyDept_Name; //부서명
            txtPos.Text = user.UserInfo.Position;

            if (user.SmsYn == "Y")
            {
                rbSMSAlllowY.Checked = true;
            }
            else
            {
                rbSMSAlllowN.Checked = true;
            }


            if (user.EmailYn == "Y")
            {
                rbEmailAlllowY.Checked = true;
            }
            else
            {
                rbEmailAlllowN.Checked = true;
            }

            if (!string.IsNullOrWhiteSpace(user.Email))
            {
                string email = Crypt.AESDecrypt256(user.Email);

                String[] email1 = email.Split('@');
                txtFirstEmail.Text = email1[0];
                txtLastEmail.Text = email1[1];
            }

            if (!string.IsNullOrWhiteSpace(user.PhoneNo))
            {
                string phone = Crypt.AESDecrypt256(user.PhoneNo);
                string[] phoneNo = phone.Split('-');

                if(phoneNo.Length == 3)
                {
                    txtSelPhone.Text = phoneNo[0] + phoneNo[1] + phoneNo[2];
                } else
                {
                    txtSelPhone.Text = phone;
                }
                
            }

            string[] telNo = user.TelNo.Split('-');

            if(telNo.Length == 3)
            {
                txtTelNo.Text = telNo[0] + telNo[1] + telNo[2];
            } else
            {
                txtTelNo.Text = user.TelNo;
            }

            string[] fax = user.FaxNo.Split('-');

            if(fax.Length == 3)
            {
                txtFaxNo.Text = fax[0] + fax[1] + fax[2];
            } else
            {
                txtFaxNo.Text = user.FaxNo;
            }
        }
    }
   
    protected void btnOk_Click(object sender, EventArgs e)
    {
        var service = new UserService();
        var svid_User = Request.Cookies["AdminSub_Svid_User"].Value.ToString();
        var smsAllowFlag = 'N';
        if (rbSMSAlllowY.Checked == true)
        {
            smsAllowFlag = 'Y';
        }
        else
        {
            smsAllowFlag = 'N';
        }

        var emailAllowFlag = 'N';
        if (rbEmailAlllowY.Checked == true)
        {
            emailAllowFlag = 'Y';
        }
        else
        {
            emailAllowFlag = 'N';
        }

        var paramList = new Dictionary<string, object>{
            {"nvar_P_SVID_USER",svid_User},
            {"nvar_P_PWD",Crypt.MD5Encryption(txtPwd.Text.Trim())},
            {"nvar_P_NAME",txtPerson.Text.Trim()},
            {"nvar_P_POSITION",txtPos.Text.Trim()},
            {"nvar_P_EMAIL",Crypt.AESEncrypt256(txtFirstEmail.Text.Trim() + "@" + txtLastEmail.Text.Trim())},
            {"nvar_P_PHONENO",Crypt.AESEncrypt256(txtSelPhone.Text.Trim())},
            {"nvar_P_SMSYN", smsAllowFlag},
            {"nvar_P_EMAILYN", emailAllowFlag},
            {"nvar_P_UPTAE", ""},
            {"nvar_P_UPJONG", ""},
            {"nvar_P_TELNO", txtTelNo.Text.Trim()},
            {"nvar_P_FAXNO", txtFaxNo.Text.Trim()}
        };
        service.UpdateUserInfo(paramList);

        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('회원정보가 수정되었습니다.');</script>");

        //  GetUserInfo();

        Response.Redirect("/AdminSub/Default.aspx");
    }
}