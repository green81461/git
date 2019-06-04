using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.User;
using Urian.Core;

public partial class Admin_Member_MemberMain_A : AdminPageBase
{
    protected string Ucode;
    UserService userService = new UserService();
    protected string totCount;

    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        if (IsPostBack == false)
        {
            //OrderEndListBind();
        }
    }
    protected void ParseRequestParameters()
    {
        //  Svid = Request.QueryString["Svid"].ToString();
        Ucode = Request.QueryString["ucode"].ToString();
    }
  

    //protected void btnExcelUpload_Click(object sender, EventArgs e)
    //{

    //    if (fuExcel.HasFile)
    //    {
    //        string duplName = string.Empty;
    //        try
    //        {
    //            string virtualPath = ConfigurationManager.AppSettings["UpLoadFolder"] + "/Temp/";
    //            string realPath = Server.MapPath(virtualPath + fuExcel.FileName);
    //            fuExcel.SaveAs(realPath);
    //            var table = CommonHelper.ExcelToDataTable(realPath, "합본");


    //            foreach (DataRow dr in table.Rows)
    //            {
    //                if (!string.IsNullOrWhiteSpace(dr["아이디"].AsText().Trim()))
    //                {
    //                    string pwd = dr["비밀번호"].AsText();
    //                    string phoneNo = dr["휴대전화번호"].AsText();
    //                    string email = dr["이메일주소"].AsText();
    //                    string gubun = dr["유형"].AsText().Trim() == "구매사" ? "BU" : "SU";
    //                    string name = dr["담당자명"].AsText().Trim();
    //                    var param = new Dictionary<string, object> {
    //                    { "nvar_P_SVID_USER", Guid.NewGuid().ToString() },
    //                    { "nvar_P_NAME", name },
    //                    { "nvar_P_ID", dr["아이디"].AsText().Trim() },
    //                    { "nvar_P_PWD", Crypt.MD5Encryption(pwd.Trim()) },
    //                    { "nvar_P_TELNO", dr["유선전화번호"].AsText().Trim() },
    //                    { "nvar_P_PHONENO", Crypt.AESEncrypt256(phoneNo.Trim()) },
    //                    { "nvar_P_FAXNO", dr["FAX번호"].AsText().Trim() },
    //                    { "nvar_P_EMAIL", Crypt.AESEncrypt256(email) },
    //                    { "nvar_P_GUBUN", gubun},
    //                    { "nvar_P_SMSYN", dr["SMS동의"].AsText().Trim()},
    //                    { "nvar_P_EMAILYN", dr["EMAIL동의"].AsText().Trim() },
    //                    { "nvar_P_ZIPCODE", dr["우편번호"].AsText().Trim() },
    //                    { "nvar_P_ADDRESS_1", dr["주소1"].AsText().Trim() },
    //                    { "nvar_P_ADDRESS_2", dr["주소2"].AsText().Trim() },
    //                    { "nvar_P_COMPANY_NO", dr["사업자번호"].AsText().Trim() },
    //                    { "nvar_P_UNIQUE_NO", dr["고유번호"].AsText().Trim() },
    //                    { "nvar_P_COMPANY_NAME", dr["기관명"].AsText().Trim() },
    //                    { "nvar_P_COMPANY_CODE", dr["기관명"].AsText().Trim()  },
    //                    { "nvar_P_DELEGATE_NAME", dr["대표자명"].AsText().Trim() },
    //                    { "nvar_P_COMPANYAREA_CODE", dr["사업장명"].AsText().Trim() },
    //                    { "nvar_P_COMPBUSINESSDEPT_CODE", dr["사업부명"].AsText().Trim() },
    //                    { "nvar_P_COMPANYDEPT_CODE", dr["부서명"].AsText().Trim() },
    //                    { "nvar_P_POSITION", dr["직책"].AsText().Trim() },
    //                    { "reVa_P_RETURN", 0},


    //                };
    //                    int returnVal = userService.SaveUserExcel(param);
    //                    if (returnVal == 2)
    //                    {
    //                        duplName += dr["아이디"].AsText().Trim() + "\\n";
    //                    }
    //                }
    //            }
    //        }
    //        catch (Exception ex)
    //        {
    //            logger.Error(ex, "USER WriteToServer Error Msg");
    //            throw;
    //        }
    //        finally
    //        {
    //            string virtualPath = ConfigurationManager.AppSettings["UpLoadFolder"] + "/Temp/";
    //            string ttt = Server.MapPath(virtualPath + fuExcel.FileName);
    //            File.Delete(ttt);
    //        }

    //        if (!string.IsNullOrWhiteSpace(duplName))
    //        {
    //            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('" + duplName + "\\n아이디가 중복되었습니다.  이외의 아이디는 등록되었습니다.');</script>");
    //        }
    //        else
    //        {
    //            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('업로드 완료 되었습니다.');</script>");
    //        }

    //    }
    //    else
    //    {
    //        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('파일을 선택해 주세요.');</script>");
    //    }
    //}

    //protected void btnExcelFormDownload_Click(object sender, EventArgs e)
    //{
    //    string uploadFolderServerPath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
    //    string fileName = "우리안 회원등록 업로드폼.xlsx";
    //    string fileFullPath = uploadFolderServerPath + "Form\\" + fileName;

    //    FileHelper.FileDownload(this.Page, fileFullPath, fileName);
    //}
}