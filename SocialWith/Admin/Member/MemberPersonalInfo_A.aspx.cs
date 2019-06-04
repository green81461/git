using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;

public partial class Admin_Member_MemberPersonalInfo_A : AdminPageBase
{
    protected string uId = string.Empty;
    protected string ucode = string.Empty;
    protected int docCnt = 0; //증빙서류 개수

    protected SocialWith.Biz.User.UserService userService = new SocialWith.Biz.User.UserService();

    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();

        if (IsPostBack == false)
        {
            GetUserInfoBind();
        }
    }

    #region <<파라미터 Get>>
    protected void ParseRequestParameters()
    {
        uId = Request.QueryString["uId"].AsText();
        ucode = Request.QueryString["ucode"].AsText();
    }
    #endregion

    #region << 데이터바인드 >>
    protected void GetUserInfoBind()
    {
        if (!string.IsNullOrWhiteSpace(uId))
        {

            //Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('잘못된 페이지 호출입니다. 관리자 메인 화면으로 이동합니다.');</script>");
            //Response.Redirect("../../Default.aspx");
            

            var paramList = new Dictionary<string, object>() {
                {"nvar_P_ID", uId}
            };

            var userInfo = userService.GetUser(paramList);

            if (userInfo != null)
            {
                hfSvidUser.Value = userInfo.Svid_User;

                lblEntryDate.Text = userInfo.EntryDate.AsText();
                lblUserId.Text = userInfo.Id;
                lblCompName.Text = userInfo.UserInfo.Company_Name;

                string compNo = userInfo.UserInfo.Company_No;
                var split_compNo = compNo.Split('-');
                if (split_compNo.Length == 3)
                {
                    lblFirstNum.Text = split_compNo[0];
                    lblMiddleNum.Text = split_compNo[1];
                    lblLastNum.Text = split_compNo[2];
                }

                lblDelegateName.Text = userInfo.UserInfo.Delegate_Name;
                lblZipCode.Text = userInfo.UserInfo.ZipCode;
                lblAddr1.Text = userInfo.UserInfo.Address_1;
                lblAddr2.Text = userInfo.UserInfo.Address_2;
                txtName.Text = userInfo.Name;
                lblDept.Text = userInfo.UserInfo.CompanyDept_Name;
                txtPos.Text = userInfo.UserInfo.Position;

                hfGubun.Value = userInfo.Gubun; //구분

                string email = Crypt.AESDecrypt256(userInfo.Email);
                var split_email = email.Split('@');

                if (split_email.Length == 2)
                {
                    txtFirstEmail.Text = split_email[0];
                    ddlLastEmail.SelectedValue = split_email[1];

                    if (ddlLastEmail.SelectedIndex == 0)
                    {
                        txtLastEmail.ReadOnly = false;
                        txtLastEmail.Text = split_email[1];
                    }
                    else
                    {
                        txtLastEmail.ReadOnly = true;
                        txtLastEmail.Text = "";
                    }
                }

                string phoneNo = Crypt.AESDecrypt256(userInfo.PhoneNo);
                var split_phoneNo = phoneNo.Split('-');

                if (split_phoneNo.Length == 3)
                {
                    txtSelPhone.Text = split_phoneNo[0] + split_phoneNo[1] + split_phoneNo[2];
                } else
                {
                    txtSelPhone.Text = phoneNo;
                }

                string telNo = userInfo.TelNo;
                var split_telNo = telNo.Split('-');

                if (split_telNo.Length == 3)
                {
                    txtTelPhone.Text = split_telNo[0] + split_telNo[1] + split_telNo[2];
                } else
                {
                    txtTelPhone.Text = telNo;
                }

                string faxNo = userInfo.FaxNo;
                var split_faxNo = faxNo.Split('-');

                if (split_faxNo.Length == 3)
                {
                    txtFax.Text = split_faxNo[0] + split_faxNo[1] + split_faxNo[2];
                } else
                {
                    txtFax.Text = faxNo;
                } 

                GetUserDocList(userInfo.Svid_User); //증빙서류 조회
            }
        }
    }

    //증빙서류 조회
    protected void GetUserDocList(string svidUser)
    {
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", svidUser }
        };

        var list = userService.GetUserDocList(paramList);

        if (list != null) docCnt = list.Count;

        lvDocList.DataSource = list;
        lvDocList.DataBind();
    }
    #endregion

    #region << 이벤트 >>
    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        string userName = txtName.Text.AsText().Trim();         // 담당자명(이름)
        string userPos = txtPos.Text.AsText().Trim();           // 직책
        string selPhone = Crypt.AESEncrypt256(txtSelPhone.Text.AsText().Trim()); //휴대폰 번호
        string email = string.Empty;                            // 전체 이메일
        string firstEmail = txtFirstEmail.Text.AsText().Trim(); // 아이디 부분 이메일
        string lastEmail = string.Empty;                        // 도메일 부분 이메일

        this.txtLastEmail.Text = Request[this.txtLastEmail.UniqueID];

        if (ddlLastEmail.SelectedIndex > 0)
            lastEmail = ddlLastEmail.SelectedValue;
        else
            lastEmail = txtLastEmail.Text.AsText().Trim();

        email = Crypt.AESEncrypt256(firstEmail + '@' + lastEmail);

        var paramList = new Dictionary<string, object>() {
              {"nvar_P_SVID_USER", hfSvidUser.Value.AsText()}
            , {"nvar_P_NAME", userName}
            , {"nvar_P_PHONENO", selPhone}
            , {"nvar_P_EMAIL", email}
            , {"nvar_P_POSITION", userPos}
            , {"nvar_P_GUBUN", hfGubun.Value.AsText()} //구분
            , {"nvar_P_UPTAE", ""} //업태
            , {"nvar_P_UPJONG", ""} //업종
            , {"reVa_P_RESULTVAL", -1}
        };

        int result = userService.UpdateUserInfo_Admin(paramList); // 회원정보 수정(이름,직책,휴대폰번호,이메일)
        
        string msg = string.Empty;
        if (result > 0)
        {
            msg = "회원정보가 수정되었습니다.";
        }
        else
        {
            msg = "회원정보 수정에 실패하였습니다. 잠시 후 다시 시도해 주세요.";
        }

        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('" + msg + "');</script>");

        //Response.Redirect("MemberMain_A.aspx");
        GetUserInfoBind();
    }
    #endregion

    #region << 파일 다운로드 >>
    protected void lvDocList_ItemCommand(object sender, ListViewCommandEventArgs e)
    {
        string uploadFolderServerPath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
        if (e.CommandName == "download")
        {
            var path = e.CommandArgument.AsText();
            var lbAttachFileName = (LinkButton)e.Item.FindControl("lbAttachFileName");
            if (lbAttachFileName != null)
            {
                var filename = lbAttachFileName.Text;


                string fileFullPath = string.Empty;
                if (!String.IsNullOrEmpty(path) && !String.IsNullOrEmpty(filename))
                {

                    fileFullPath = uploadFolderServerPath + path + filename;

                    FileHelper.FileDownload(this.Page, fileFullPath, filename);
                }
            }
        }
    }
    #endregion
}