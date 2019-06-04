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

public partial class Admin_Member_MemberMain_B : AdminPageBase
{
    protected string Ucode;
    UserService userService = new UserService();
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        if (IsPostBack == false)
        {
            //UserListBind();
        }
    }

    #region << 데이터 바인드 >>
    protected void UserListBind(int page = 1)
    {
        //var paramList = new Dictionary<string, object>{
        //      {"nvar_P_GUBUN", "B"}
        //    , {"nvar_P_CONFIRMFLAG", ddlGubun.SelectedValue}
        //    , {"nvar_P_SEARCHKEYWORD", txtSearch.Value.AsText()}
        //    , {"nume_P_PAGENO", page}
        //    , {"nume_P_PAGESIZE", 20}
        //};

        //SocialWith.Biz.User.UserService userService = new SocialWith.Biz.User.UserService();

        //var list = userService.GetUserList_Admin(paramList);
        //int listCount = 0;

        //if ((list != null) && (list.Count > 0))
        //{
        //    listCount = list.FirstOrDefault().TotalCount;

        //    for (int i=0; i<list.Count; i++)
        //    {
        //        list[i].PhoneNo = Crypt.AESDecrypt256(list[i].PhoneNo.AsText());
        //    }
        //}

        //ucListPager.TotalRecordCount = listCount;
        //lvMemberListB.DataSource = list;
        //lvMemberListB.DataBind();
    }
    #endregion

    #region << 이벤트 >>
    //protected void ucListPager_PageIndexChange(object sender)
    //{
    //    UserListBind(ucListPager.CurrentPageIndex);
    //}


    protected void btnSearch_Click(object sender, ImageClickEventArgs e)
    {
        //UserListBind();
    }




    #endregion
    protected void ParseRequestParameters()
    {
        //  Svid = Request.QueryString["Svid"].ToString();
        Ucode = Request.QueryString["ucode"].ToString();
    }




    protected void btnExcelUpload_Click(object sender, EventArgs e)
    {
        logger.Debug("----------------- 일괄회원 업로드 이벤트 발생 -----------------");


        if (fuExcel.HasFile)
        {
            string duplName = string.Empty; //회원(U_USER) ID 중복
            string billDuplName = string.Empty; //세금계산서(BILL_MEMBER) 회원정보 ID 중복
            string codeNoneName = string.Empty; //회사관련 코드들 중 존재하지 않는 코드
            string comNoYnFlag = rbComNoN.Checked == true ? "N" : "Y"; //사업자번호 유무(Y:유, N:무)

            logger.Debug("사업자번호 유무 : " + comNoYnFlag);

            try
            {
                string virtualPath = ConfigurationManager.AppSettings["UpLoadFolder"] + "/Temp/";
                string realPath = Server.MapPath(virtualPath + fuExcel.FileName);
                fuExcel.SaveAs(realPath);
                var table = CommonHelper.ExcelToDataTable(realPath, "회원가입");

                logger.Debug("----------------- 엑셀 파일 읽음. -----------------");

                foreach (DataRow dr in table.Rows)
                {

                    if (!string.IsNullOrWhiteSpace(dr["아이디"].AsText().Trim()) && !string.IsNullOrWhiteSpace(dr["이메일주소"].AsText().Trim()))
                    {

                        logger.Debug("----------------- 시작 아이디 : " + dr["아이디"].AsText().Trim() + "    -----------------");


                        string comGubunCode = dr["회사연동코드"].AsText().Trim(); //회사구분코드
                        string comCode = dr["회사코드"].AsText().Trim(); //회사코드
                        string svidRole = dr["유형"].AsText().Trim(); //사용자유형(A1/B1/B2/BC1/BC2/BC3/C1/C2)
                        string userId = dr["아이디"].AsText().Trim();
                        string pwd = dr["비밀번호"].AsText().Trim();
                        string comNm = dr["기관명"].AsText().Trim();
                        string comNo = dr["사업자번호"].AsText().Trim();
                        string uniqueNo = dr["고유번호"].AsText().Trim();
                        string delegateNm = dr["대표자명"].AsText().Trim();
                        string zipCode = dr["우편번호"].AsText().Trim();
                        string address1 = dr["주소1"].AsText().Trim();
                        string address2 = dr["주소2"].AsText().Trim();
                        string userNm = dr["담당자명"].AsText().Trim();
                        string sabun = dr["사번"].AsText().Trim();
                        string comAreaCode = dr["사업장코드"].AsText().Trim();
                        string comAreaNm = dr["사업장명"].AsText().Trim();
                        string comBusinessDeptCode = dr["사업부코드"].AsText().Trim();
                        string comBusinessDeptNm = dr["사업부명"].AsText().Trim();
                        string comDeptCode = dr["부서코드"].AsText().Trim();
                        string comDeptNm = dr["부서명"].AsText().Trim();
                        string enterUrlDomain = dr["구매사주문유형(가입경로)"].AsText().Trim();
                        string userPosition = dr["직책"].AsText().Trim();
                        string email = dr["이메일주소"].AsText().Trim();
                        string phoneNo = dr["휴대전화번호"].AsText().Replace(" ", "");
                        string telNo = dr["유선전화번호"].AsText().Replace(" ", "");
                        string faxNo = dr["FAX번호"].AsText().Replace(" ", "");
                        string smsYN = dr["SMS동의"].AsText().Trim();
                        string emailYN = dr["EMAIL동의"].AsText().Trim();
                        var svidUser = Guid.NewGuid().ToString(); //사용자 시퀀스
                        var createDeliveryId = Guid.NewGuid().ToString(); // 배송지 시퀀스

                        var param = new Dictionary<string, object> {

                        { "nvar_P_SVID_USER", svidUser },
                        { "nvar_P_GUBUN", comGubunCode},
                        { "nvar_P_COMPANY_CODE", comCode},
                        { "nvar_P_SVID_ROLE", svidRole},
                        { "nvar_P_ID", userId },
                        { "nvar_P_PWD", Crypt.MD5Encryption(pwd) },
                        { "nvar_P_COMPANY_NAME", comNm },
                        { "nvar_P_COMPANY_NO", comNo },
                        { "nvar_P_UNIQUE_NO", uniqueNo },
                        { "nvar_P_DELEGATE_NAME", delegateNm },
                        { "nvar_P_ZIPCODE", zipCode },
                        { "nvar_P_ADDRESS_1", address1 },
                        { "nvar_P_ADDRESS_2", address2 },
                        { "nvar_P_NAME", userNm },
                        { "nvar_P_SABUN", sabun },
                        { "nvar_P_COMPANYAREA_CODE", comAreaCode },
                        { "nvar_P_COMPANYAREA_NAME", comAreaNm },
                        { "nvar_P_COMPBUSINESSDEPT_CODE", comBusinessDeptCode },
                        { "nvar_P_COMPBUSINESSDEPT_NAME", comBusinessDeptNm },
                        { "nvar_P_COMPANYDEPT_CODE", comDeptCode },
                        { "nvar_P_COMPANYDEPT_NAME", comDeptNm },
                        { "nvar_P_ENTERURLDOMAIN", enterUrlDomain },
                        { "nvar_P_POSITION", userPosition },
                        { "nvar_P_EMAIL", Crypt.AESEncrypt256(email) },
                        { "nvar_P_PHONENO", Crypt.AESEncrypt256(phoneNo) },
                        { "nvar_P_TELNO", telNo },
                        { "nvar_P_FAXNO", faxNo },
                        { "nvar_P_SMSYN", smsYN },
                        { "nvar_P_EMAILYN", emailYN },
                        { "nvar_P_SVID_DELIVERY", createDeliveryId },
                        { "nvar_P_ENTCODE", "A634"}, //세금계산서발행테이블용
                        { "nvar_P_COMNOYN", comNoYnFlag }, //사업자번호 유무
                        { "reVa_P_RETURN", 0}

                    };

                        int returnVal = userService.SaveUserExcel_B(param); //구매사 회원 일괄 엑셀업로드 저장

                        logger.Debug(userId + "   => 프로시저 실행 결과값 : " + returnVal);

                        // -- 결과코드정보 --
                        // 0:실행실패
                        // 99:BILL_MEMBER 저장 전까지 성공
                        // 100:성공
                        // 401:U_USER 에서 ID 중복
                        // 402:참고할 계정정보가 없음.
                        // 501:BILL_MEMBER 에서 ID 중복
                        // 601:회사관련 코드들 중 존재하지 않는 코드

                        if (returnVal == 401)
                        {
                            duplName += userId + "\\n";
                        }
                        if (returnVal == 501)
                        {
                            billDuplName += userId + "\\n";
                        }
                        if (returnVal == 601)
                        {
                            codeNoneName += userId + "\\n";
                        }

                    }
                    else
                    {
                        logger.Debug("----------------- 제외된 아이디 : " + dr["아이디"].AsText().Trim() + "    -----------------");
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "USER WriteToServer Error Msg");
                throw;
            }
            finally
            {
                string virtualPath = ConfigurationManager.AppSettings["UpLoadFolder"] + "/Temp/";
                string ttt = Server.MapPath(virtualPath + fuExcel.FileName);
                File.Delete(ttt);
            }


            if (!string.IsNullOrWhiteSpace(duplName) || !string.IsNullOrWhiteSpace(billDuplName) || !string.IsNullOrWhiteSpace(codeNoneName))
            {
                //회원정보 중복
                if (!string.IsNullOrWhiteSpace(duplName))
                {
                    logger.Error("========= 회원 일괄 엑셀업로드 시 회원 ID 중복값(SWP_USER) ========");
                    logger.Error(duplName);
                    logger.Error("=================================================");

                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('" + duplName + "\\n아이디가 중복되었습니다.  이외의 아이디는 회원정보에 등록되었습니다.');</script>");

                }

                //세금계산서 회원정보 중복
                if (!string.IsNullOrWhiteSpace(billDuplName))
                {
                    logger.Error("========= 회원 일괄 엑셀업로드 시 세금계산서 ID 중복값(BILL_MEMBER) ========");
                    logger.Error(billDuplName);
                    logger.Error("=================================================");

                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('" + billDuplName + "\\n아이디가 중복되었습니다.  이외의 아이디는 세금계산서 회원정보에 등록되었습니다.');</script>");
                }

                //회사관련 코드들 중 존재하지 않는 코드
                if (!string.IsNullOrWhiteSpace(codeNoneName))
                {
                    logger.Error("========= 회원 일괄 엑셀업로드 시 회사관련 코드들 없음 ========");
                    logger.Error(codeNoneName);
                    logger.Error("=================================================");

                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('" + codeNoneName + "\\n아이디의 회사관련 코드들이 없습니다.  이외의 아이디는 성공적으로 등록되었습니다.');</script>");
                }
            }
            else
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('업로드 완료 되었습니다.');</script>");
            }

        }
        else
        {
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('파일을 선택해 주세요.');</script>");
        }
    }

    protected void btnExcelFormDownload_Click(object sender, EventArgs e)
    {
        string uploadFolderServerPath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
        string fileName = "회원등록 업로드폼.xlsx";
        string fileFullPath = uploadFolderServerPath + "Form\\" + fileName;

        FileHelper.FileDownload(this.Page, fileFullPath, fileName);
    }
    
}