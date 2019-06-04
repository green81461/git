using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.DistCss;
using SocialWith.Biz.User;
using Urian.Core;

public partial class Member_MemberIdPwSch : LoginPageBase
{

    protected UserService service = new UserService();
    protected DistCssService distCssService = new DistCssService();
    protected string _loginLogoPath = string.Empty;
    protected string _enterDomainUrl = string.Empty;
    protected string _sslFlag = string.Empty;
    protected string _distCompName = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    protected void GetSiteDistCss()
    {
        
        if (DistCssObject == null)
        {
            _loginLogoPath = Page.ResolveClientUrl("SiteManagement/Default/Login/login_logo.jpg");
            _enterDomainUrl = "www.socialwith.co.kr";
            _distCompName = "소셜위드";
        }
        else
        {
            _loginLogoPath = string.IsNullOrWhiteSpace(DistCssObject.LoginCompnayLogoPath) ? Page.ResolveClientUrl("SiteManagement/Default/Login/login_logo.jpg") : DistCssObject.LoginCompnayLogoPath;
            _enterDomainUrl = string.IsNullOrWhiteSpace(DistCssObject.EnterUrl) ? "www.socialwith.co.kr" : DistCssObject.EnterUrl;
            _distCompName  = string.IsNullOrWhiteSpace(DistCssObject.DistCompanyName) ? "소셜위드" : DistCssObject.DistCompanyName;
        }
        

    }


    protected void btnSearchPwd_Click(object sender, EventArgs e)
    {
        GetSiteDistCss();
        string emailcheck = txtPWEmail1.Text.Trim() + '@' + txtPWEmail2.Text.Trim();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_ID",txtUserId.Text.Trim()},
            { "nvar_P_EMAIL",Crypt.AESEncrypt256(txtPWEmail1.Text.Trim() + '@' + txtPWEmail2.Text.Trim())},
            { "nvar_P_COMPANYNO",txtPWComnum1.Text.Trim() + '-' + txtPWComnum2.Text.Trim() + '-' + txtPWComnum3.Text.Trim()},
        };

        var userInfo = service.User_SearchPWD(paramList);
        if ((userInfo != null) && (userInfo.ReturnValue == "1"))
        {

            string password = string.Empty;
            password = StringValue.GetRandomPassword(8); //랜덤패스워드 생성



            var fromMail = ConfigurationManager.AppSettings["FromMail"].AsText("service@socialwith.co.kr"); // 보내는 메일
            string subject = "[" + _distCompName+"]" + "회원님의 임시 비밀번호 입니다.";
            string logoPath = _enterDomainUrl + ConfigurationManager.AppSettings["UpLoadFolder"].AsText("/UploadFile/") + _loginLogoPath;
            string bodyContent = @"<table width='700' border='0' cellpadding='0' cellspacing='0' bgcolor='#ffffff'>
                                    <tr>
                                        <td width='700' height='100' style='border-bottom:2px solid #000; color:#fff; font-size:22px; font-weight:bold;' >
                                            <img src='{0}'/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor='#FFFFFF' height='280' align='center'>
                                        <table width='700' border='0' cellpadding='0' cellspacing='0'>
                                                <tr>
                                                    <td height='250' style='border:1px solid #afafaf;'>
                                                        <p style='font-size:17px; margin:0 40px;' > 회원님의 임시 비밀번호 입니다.</p ><br/>
                                                            <p style = 'font-size:14px; margin:0 40px;' > 회원님의 비밀번호가 <span style='font-weight:bold; color:#0066cc;'>{1}</span > 로 변경되었습니다.</p><br/>
                                                                <a href='{2}' style='font-size:12px;display:inline-block; padding:8px 20px; color:#fff;text-decoration:none; background-color:#223570; margin:10px 0 0 40px'> 사이트 바로가기 </a>
                                                    </td>
                                                </tr>
                                           </table>
                                        </td>
                                       </tr>
                                       </table>";
            string httpProtocol = _sslFlag == "Y" ? "https://" : "http://";
            string bodyMessege = string.Format(bodyContent, httpProtocol + logoPath, password, httpProtocol + _enterDomainUrl);


            bodyMessege += Environment.NewLine;

            var updateParamList = new Dictionary<string, object>() {

                { "nvar_P_ID",txtUserId.Text.Trim()},
                { "nvar_P_PWD",Crypt.MD5Encryption(password)} //암호화된 임시비밀번호로 업데이트
            };
            try
            {
                service.UpdateUserPassword(updateParamList);//유저패스워드 임시비밀번호로 업데이트

            }
            catch (Exception ex)
            {
                if (IsErrorEnabled)
                {
                    logger.Error(ex, "UpdateUserPassword Error");
                }
            }
            CommonHelper.SendMailService(fromMail, emailcheck, subject, bodyMessege);  // userpassword 업데이트가 성공하면 메일전송
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('해당 메일로 패스워드를 전송했습니다.'); return false   ;</script>");
        }
        else
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('해당 사용자가 없습니다.');</script>");
        }
    }

    protected void btnSearchId_Click(object sender, EventArgs e)
    {
        GetSiteDistCss();

        var Emailadd = txtEmail1.Text.Trim() + '@' + txtEmail2.Text.Trim();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_NAME",txtUserName.Text.Trim()},
            { "nvar_P_EMAIL",Crypt.AESEncrypt256(txtEmail1.Text.Trim() + '@' + txtEmail2.Text.Trim())},
            { "nvar_P_COMPANYNO",txtComnum1.Text.Trim() + '-' + txtComnum2.Text.Trim() + '-' + txtComnum3.Text.Trim()},
         };
        var userInfo = service.User_SearchID(paramList);

        if ((userInfo != null) && (userInfo.Email != null))
        {
            string subject = "[" + _distCompName + "]" + "회원님의 가입 아이디 입니다.";
            string logoPath = _enterDomainUrl+ ConfigurationManager.AppSettings["UpLoadFolder"].AsText("/UploadFile/") + _loginLogoPath;
            string bodyContent = @"<table width='700' border='0' cellpadding='0' cellspacing='0' bgcolor='#ffffff'>
                                    <tr>
                                        <td width='700' height='100' style='border-bottom:2px solid #000; color:#fff; font-size:22px; font-weight:bold;' >
                                            <img src='{0}'/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor='#FFFFFF' height='280' align='center'>
                                        <table width='700' border='0' cellpadding='0' cellspacing='0'>
                                                <tr>
                                                    <td height='250' style='border:1px solid #afafaf;'>
                                                        <p style='font-size:17px; margin:0 40px;' > 회원님의 가입 아이디 입니다.</p ><br/>
                                                            <p style = 'font-size:14px; margin:0 40px;' > 회원님의 아이디는 <span style='font-weight:bold; color:#0066cc;'>{1}</span > 입니다.</p><br/>
                                                                <a href='{2}' style='font-size:12px;display:inline-block; padding:8px 20px; color:#fff;text-decoration:none; background-color:#223570; margin:10px 0 0 40px'> 사이트 바로가기 </a>
                                                    </td>
                                                </tr>
                                           </table>
                                        </td>
                                       </tr>
                                       </table>";
            string httpProtocol = _sslFlag == "Y" ? "https://" : "http://";
            string bodyMessege = string.Format(bodyContent, httpProtocol + logoPath, userInfo.Id, httpProtocol + _enterDomainUrl);
            bodyMessege += Environment.NewLine;

            var fromMail = ConfigurationManager.AppSettings["FromMail"].AsText("service@socialwith.co.kr"); // 보내는 메일
            CommonHelper.SendMailService(fromMail, Crypt.AESDecrypt256(userInfo.Email), subject, bodyMessege);  // 메일전송
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('해당 메일로 아이디를 전송했습니다.'); location.href='../Default.aspx';</script>");
        }
        else
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('해당 사용자가 없습니다.');</script>");
        }
    }
}