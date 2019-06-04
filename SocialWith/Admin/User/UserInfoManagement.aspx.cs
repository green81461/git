using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Data.Company;
using Urian.Core;

public partial class Admin_User_UserInfoManagement : AdminPageBase
{
    protected SocialWith.Biz.User.UserService UserService = new SocialWith.Biz.User.UserService();
    protected SocialWith.Biz.Comapny.CompanyService CompanyService = new SocialWith.Biz.Comapny.CompanyService();

    protected void Page_Init(object sender, EventArgs e)
    {
       // this.Form.Method = "Post";
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack == false)
        {
            GetDefaultData();
        }
    }
    
    protected void GetDefaultData() {
        var paramList = new Dictionary<string, object>() {
            //{"nvar_P_ID", "urianuser2"} /////////////// 임시로 사용자 아이디 지정해 놓음....... 나중에 정식코드로 수정 필요!!!!!!!!!!
            {"nvar_P_ID", "urianbc1"}
        };

        //회사정보 저장에 필요한 데이터를 갖고온다
        var user = UserService.GetUser(paramList);
        if (user != null)
        {
            lblCompanyNo.Text = user.UserInfo.Company_No;
            char delFlag = user.UserInfo.Company_Delflag;
            hfSelectCompDelFlag.Value = delFlag.ToString(); // 히든필드에 회사거래중지여부 값 저장

            // 회사 거래중지 여부 설정
            if (delFlag.Equals('Y'))
            {
                rbnDelflagN.Checked = false;
                rbnDelflagY.Checked = true;
                
            } else
            {
                rbnDelflagY.Checked = false;
                rbnDelflagN.Checked = true;
            }

            // 회사구분 정식 코드값이 있는 경우
            if (user.Gubun.AsText().Length == 5)
            {
                SocialCompanyDTO socialComp = GetSocialCompany(user.Gubun.AsText()); // 코드값에 대한 회사구분 정보 조회

                txtSocialCompCode.Text = socialComp.SocialCompany_Code;
                lblSocialCompName.Text = socialComp.SocialCompany_Name;
                hfSelectSocialCompCode.Value = socialComp.SocialCompany_Code;
                hfSelectSocialCompName.Value = socialComp.SocialCompany_Name;
                hfGubun.Value = socialComp.SocialCompany_Code.Substring(0,2); // 코드의 앞문자만 저장

            // 없는 경우 아무것도 보여주지 않음
            }
            else
            {
                txtSocialCompCode.Text = "";
                lblSocialCompName.Text = "";
                hfGubun.Value = user.Gubun; // 사용자 정보에 있는 회사구분 코드
            }

            hfOldSocialCompCode.Value = user.Gubun; // 사용자 DB에 있는 회사구분코드값(바뀐값과 비교를 위해 저장)

            // 회사코드 관련 값 설정
            lblCompanyName.Text = user.UserInfo.Company_Name;
            txtCompnayCode.Text = user.UserInfo.Company_Code;
            hfSelectCompanyName.Value = user.UserInfo.Company_Name;

            // 사업장코드 관련 값 설정
            txtAreaCode.Text = user.UserInfo.CompanyArea_Code.ToString();
            lblAreaName.Text = user.UserInfo.CompanyArea_Name;
            hfSelectAreaName.Value = user.UserInfo.CompanyArea_Name;

            // 사업부코드 관련 값 설정
            txtBusinessCode.Text = user.UserInfo.CompBusinessDept_Code;
            lblBusinessName.Text = user.UserInfo.CompBusinessDept_Name;
            hfSelectBusinessName.Value = user.UserInfo.CompBusinessDept_Name;

            // 부서코드 관련 값 설정
            txtDeptCode.Text = user.UserInfo.CompanyDept_Code;
            lblDeptName.Text = user.UserInfo.CompanyDept_Name;
            hfSelectDeptName.Value = user.UserInfo.CompanyDept_Name;

            hfSvidUSer.Value = user.Svid_User;
            hfCompanyNo.Value = user.UserInfo.Company_No; //히든필드에 사업자 번호 저장
            hfSelectCompanyCode.Value = user.UserInfo.Company_Code; //히든필드에 회사코드 저장
            hfSelectAreaCode.Value = user.UserInfo.CompanyArea_Code.ToString(); //히든필드에 사업장코드 저장
            hfSelectBusinessCode.Value = user.UserInfo.CompBusinessDept_Code; //히든필드에 사업부코드 저장
            hfSelectDeptCode.Value = user.UserInfo.CompanyDept_Code; //히든필드에 부서코드 저장
            hfOldCompCode.Value = user.UserInfo.Company_Code; // 히든필드에 현재 회사코드 저장
        }
    }

    #region << 데이터 조회 - GetSocialCompany >>
    protected SocialCompanyDTO GetSocialCompany(string code)
    {
        SocialCompanyDTO socialComp = new SocialCompanyDTO();

        var paramList = new Dictionary<string, object>() {
            {"nvar_P_SOCIALCOMPANY_CODE", code}
        };

        socialComp = CompanyService.GetSocialCompany(paramList);
        
        return socialComp;
    }
    #endregion

    //유저정보 업데이트
    protected void btnUserInfoUpdate_Click(object sender, EventArgs e)
    {
        string compCode = hfSelectCompanyCode.Value;
        string compName = hfSelectCompanyName.Value;
        string areaCode = hfSelectAreaCode.Value;
        string areaName = hfSelectAreaName.Value;
        string businessCode = hfSelectBusinessCode.Value;
        string businessName = hfSelectBusinessName.Value;
        string deptCode = hfSelectDeptCode.Value;
        string deptName = hfSelectDeptName.Value;
        string companyNo = hfCompanyNo.Value; // 사업자번호
        string oldCompCode = hfOldCompCode.Value; // DB에서 가져온 기존 회사코드
        string socialCompCode = hfSelectSocialCompCode.Value;
        string socialCompName = hfSelectSocialCompName.Value;
        string oldSocialCompCode = hfOldSocialCompCode.Value; // 기존 회사구분코드

        txtSocialCompCode.Text = socialCompCode;
        txtCompnayCode.Text = compCode;
        txtAreaCode.Text = areaCode;
        txtBusinessCode.Text = businessCode;
        txtDeptCode.Text = deptCode;

        lblSocialCompName.Text = socialCompName;
        lblCompanyName.Text = compName;
        lblAreaName.Text = areaName;
        lblBusinessName.Text = businessName;
        lblDeptName.Text = deptName;

        char delFlag = 'N';

        // 회사 거래중지유무
        if (rbnDelflagY.Checked == true)
        {
            delFlag = 'Y';
        }
        else
        {
            delFlag = 'N';
        }

        var paramList = new Dictionary<string, object> {
                { "nvar_P_SVID_USER", hfSvidUSer.Value},
                { "nvar_P_COMPANY_CODE", compCode.Trim()},
                { "nvar_P_COMPANY_NAME", compName.Trim()},
                { "nume_COMPANYAREA_CODE", areaCode.Trim()},
                { "nvar_P_COMPBUSINESSDEPT_CODE", businessCode.Trim()},
                { "nvar_P_COMPANYDEPT_CODE", deptCode.Trim()},
                { "char_P_DELFLAG", delFlag},
                { "nvar_P_COMPANY_NO", companyNo},
                { "nvar_P_OLD_COMPCODE", oldCompCode},
                { "nvar_P_SOCIALCOMPANY_CODE", socialCompCode},
                { "nvar_P_OLD_SOCIALCOMPANY_CODE", oldSocialCompCode}
            };

        UserService.UpdateUserCompanyInfo(paramList);

        // 기존 코드값이 변경되었으므로 변경된 값으로 다시 저장
        hfOldCompCode.Value = compCode;
        hfOldSocialCompCode.Value = oldSocialCompCode;

        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('저장되었습니다.');</script>");
    }
}