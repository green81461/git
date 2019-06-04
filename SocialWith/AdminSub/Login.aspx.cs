using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;

public partial class Admin_Login : System.Web.UI.Page
{
    protected SocialWith.Biz.User.UserService service = new SocialWith.Biz.User.UserService();
    protected void Page_Load(object sender, EventArgs e)
    {

        //개발자용 피씨나 socialwith메인사이트 제외하고 관리자 페이지 접근 제한

        string ip = HttpContext.Current.Request.UserHostAddress;

        if (!(ip == "127.0.0.1" || ip == "::1") && CommonHelper.SiteName() != "socialwith")
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('접근권한이 없습니다.'); location.href='../../Member/Login.aspx'</script>");
        }

        if(IsPostBack == false)
        {
            MemberBind();
        }
    }


    

    protected void MemberBind()
    {
        var saveIdFlagAdmin = Request.Cookies["AdminSaveIdFlag"];
        var saveIdCookieAdmin = Request.Cookies["AdminSaveId"];

        if ((saveIdFlagAdmin != null) && (saveIdFlagAdmin.Value == "Y") && saveIdCookieAdmin != null)
        {
            var saveIdAdmin = Request.Cookies["AdminSaveId"].Value;
            ckbSaveId.Checked = true;
            txtLoginId.Text = saveIdAdmin;

        }
        else
        {
            ckbSaveId.Checked = false;
            txtLoginId.Text = "";
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        var loginId = txtLoginId.Text.Trim();
        var pwd = txtPwd.Text.Trim();

        var saveIdFlag = ckbSaveId.Checked == true ? "Y" : "N"; // 아이디 저장 구분값(Y:저장, N:저장안함)

        HttpCookie cookieSaveIdFlag = new HttpCookie("AdminSaveIdFlag", saveIdFlag);
        HttpCookie cookieSaveId = new HttpCookie("AdminSaveId", loginId);

        // 쿠키 30일간 저장
        cookieSaveIdFlag.Expires = DateTime.Now.AddDays(30);
        Response.Cookies.Add(cookieSaveIdFlag);
        Response.Cookies.Add(cookieSaveId);

        string url = Request.Url.Host;
        if (url.Trim().StartsWith("www"))
        {
            url = url.Trim().Split('.')[1];
        }
        else
        {
            url = url.Trim().Split('.')[0];
        }

        var paramList = new Dictionary<string, object> {
            {"nvar_P_ID", loginId },
            //{"nvar_P_PASSWORD", Crypt.MD5Encryption(pwd) }, // 비밀번호 암호화
             {"nvar_P_PASSWORD", Crypt.MD5Encryption(pwd) }, // 비밀번호 암호화
            {"nvar_P_URL", url } //사이트명
        };

        var userInfo = service.GetLoginUserInfo(paramList);
        

        // 사용자 정보가 있는 경우
        if ((userInfo != null) && (userInfo.Id != null) && userInfo.Gubun.Substring(0, 2) == "SU")
        {

            if (userInfo.ConfirmFlag == "Y")
            {
                var insertParamList = new Dictionary<string, object>
                {
                    {"nvar_P_SVIDUSER", userInfo.Svid_User },
                    {"nvar_P_GUBUN", "2" }, // 1.구매사 2.판매사 3.RMP 4.관리자, 5 그룹G
                    {"nvar_P_INFO",  "1" } // 1.로그인 2.장바구니 3.주문 4.결제
                };

                service.InsertLoginHity(insertParamList);
                string redirectUrl = "~/Admin/Default.aspx";

                CommonHelper.SetLogIn(userInfo.Svid_User, loginId, redirectUrl, userInfo.Gubun.Substring(0, 2)); // 로그인 세션 처리

            }

            // 사용자 정보가 없는 경우
        }
        else
        {
            lblLoginMsg.Text = "아이디 또는 비밀번호가 맞지 않습니다.";
        }
    }
}