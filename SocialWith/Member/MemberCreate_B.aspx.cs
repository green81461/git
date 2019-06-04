using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using Urian.Core;
using SocialWith.Biz.Comapny;

public partial class Member_MemberCreate_B : LoginPageBase
{
    protected SocialWith.Biz.User.UserService UserService = new SocialWith.Biz.User.UserService();
    protected SocialWith.Biz.Board.BoardService BoardService = new SocialWith.Biz.Board.BoardService();
    protected CompanyService CompanyService = new CompanyService();
    protected string OrderSaleCompCode = string.Empty;
    protected string AdminUserId = string.Empty;
    protected string FreeCompYn = string.Empty;
    protected string AutoConfirmYN = "N";
    protected string Gubun = "BU";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack == false)
        {
            DefaultDataBind();
        }
    }

    protected void DefaultDataBind()
    {
        
    }



    public void UserDocSave(string createUserId, int docIndex, int channel, string createAttachId)
    {
        var createDocId = Guid.NewGuid().ToString();

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_SVID_DOC", createDocId},
            {"nvar_P_SVID_USER", createUserId},
            {"nume_P_DOC_NO", docIndex},
            {"nvar_P_MAP_CODE", "MEMBER"},
            {"nume_P_COMM_TYPE", 1},
            {"nume_P_COMM_CHANNEL", channel},
            {"nvar_P_SVID_ATTACH", createAttachId}
        };

        UserService.SaveUserDoc(paramList);
    }

    public void AttachFileSave(string uploadFileName, int fileSize, string svid, string attachSeq, int docIndex, string ext)
    {
        string iFileName = "D" + "_" + txtId.Text.Trim() + "_" + docIndex + "_" + uploadFileName; //논리파일명
        string filePath = "\\Member\\" + "B" + "\\" + txtId.Text.Trim() + "\\";
        var paramList = new Dictionary<string, object>
        {
            //첨부파일
            {"nvar_P_SVID_ATTACH", attachSeq},
            {"nvar_P_SVID_BOARD", svid},
            {"nume_P_ATTACH_NO", docIndex },
            {"nvar_P_ATTACH_P_NAME",uploadFileName },
            {"nvar_P_ATTACH_I_NAME",iFileName },
            {"nvar_P_ATTACH_EXT", ext},
            {"nume_P_ATTACH_DOWNCNT",0 },
            {"nvar_P_ATTACH_SIZE", fileSize },
            {"nvar_P_ATTACH_PATH", filePath }
        };

        BoardService.SaveBoardAttach(paramList);       //파일 DB 저장
    }


    private void SendMMS(string userType, string type)
    {

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_TYPE", userType},
        };

        var list = UserService.GetSMSUserList(paramList);

        if (list != null)
        {
            string incomingUser = string.Empty;

            foreach (var item in list)
            {
                incomingUser += item.Name + "^" + Crypt.AESDecrypt256(item.PhoneNo).Replace("-", "") + "|";
            }
            string content = string.Empty;
            if (type == "auto")
            {
                content = "[구매사 신규가입]\r\n회사명 : " + txtOrganName.Text.Trim() + "\r\n아이디 : " + txtId.Text.Trim() + "\r\n\r\n" + "'자동승인' 회원입니다. \r\n주문유형 검토 바랍니다.";
            }
            else if (type == "manual")
            {
                content = "[구매사 신규가입]\r\n회사명 : " + txtOrganName.Text.Trim() + "\r\n아이디 : " + txtId.Text.Trim() + "\r\n\r\n" + "'승인 대기 중' 이니 검토 후 회원세팅 진행 바랍니다.";
            }

            if (!string.IsNullOrWhiteSpace(incomingUser))
            {
                var paramList2 = new Dictionary<string, object>
                {
                    {"nvar_P_SUBJECT", "[구매사 신규가입]"},
                    {"nvar_P_DEST_INFO", incomingUser.Substring(0, incomingUser.Length-1)},
                    {"nvar_P_MSG", content},
                };

                UserService.MMSInsert(paramList2);
            }

        }
    }

    public void AttachFileUpload()
    {
        int maxSize = int.Parse(ConfigurationManager.AppSettings["UploadFileMaxSize"]);
        FileHelper.FileUpload(fuRegist, this.Page, fuRegist.FileName, maxSize, txtId.Text.Trim(), "MemberB", txtId.Text.Trim()); // 파일 업로드

    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        int returnVal = 0;

        try
        {
            if (SiteName != "socialwith")
            {
                var param = new Dictionary<string, object> {

                    { "nvar_P_SITEURL", SiteName.AsText("socialwith").ToLower()}
                };
                var comp = CompanyService.GetOrderSaleCompInfoBySiteUrl(param);
                if (comp != null)
                {
                    OrderSaleCompCode = comp.Company_Code;
                    AdminUserId = comp.ADMINUSERID;
                    Gubun = comp.Gubun;
                    FreeCompYn = comp.FreeCompanyYN;
                    AutoConfirmYN = comp.AutoConfirmYN.AsText("N");


                }
                else
                {
                    SiteName = "socialwith";
                }
            }

            var createUserId = Guid.NewGuid().ToString();
            var createDeliveryId = Guid.NewGuid().ToString(); // 배송지 시퀀스
            var selPhone = txtSelPhone.Text.Trim();
            var email = txtEmail1.Text.Trim() + "@" + txtEmail2.Text.Trim(); // 이메일
            var domain = hfDomain.Value.AsText(); //접속 도메인
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

            string compCode = string.Empty;


            string lastCode = CompanyService.GetLastCompanyCode();
            if (!string.IsNullOrWhiteSpace(lastCode))
            {
                compCode = StringValue.GetNextCompanyCode(lastCode); //코드 자동생성
            }
            else
            {
                compCode = "CC000001"; //최초 회사 코드
            }

            var paramList = new Dictionary<string, object>
            {
                // 리스트
                {"nvar_P_SITENAME", SiteName.AsText("socialwith").ToLower()},
                {"nvar_P_SVID_USER", createUserId},
                {"nvar_P_NAME", txtChargeName.Text.Trim()},
                {"nvar_P_ID", txtId.Text.Trim()},
                {"nvar_P_PWD", Crypt.MD5Encryption(txtPwd.Text.Trim())}, // 비밀번호 암호화
                {"nvar_P_TELNO", txtTelPhone.Text.Trim()},
                {"nvar_P_PHONENO", Crypt.AESEncrypt256(selPhone)}, // 휴대전화번호 암호화
                {"nvar_P_FAXNO", txtFax.Text.Trim()},
                {"nvar_P_EMAIL", Crypt.AESEncrypt256(email)}, // 이메일 암호화
                {"nvar_P_GUBUN", Gubun},
                {"nvar_P_COMPGUBUN","BU" },
                {"nvar_P_SVID_ROLE", "A1"}, //나중에 협의
                {"char_P_CONFIRMFLAG", ""},
                {"nvar_P_PRICERULE", "0"},
                {"nvar_P_SMSYN", smsAllowFlag},
                {"nvar_P_EMAILYN", emailAllowFlag},
                {"nume_P_LOGINCOUNT", "0"},
                {"char_P_LOGINCHECK", "N"},
                {"char_P_DELFLAG", "N"},

                // Info
                {"char_P_ZIPCODE",hfPostalCode.Value.Trim() }, //readonly textbox는 값을 못갖고 오기에 히든필드에 저장 
                {"nvar_P_ADDRESS_1",hfAddress1.Value.Trim() }, //readonly textbox는 값을 못갖고 오기에 히든필드에 저장
                {"nvar_P_ADDRESS_2",txtAddress2.Text.Trim()},
                {"nvar_P_COMPANY_NO",txtBusinessNum1.Text.Trim() +"-"+txtBusinessNum2.Text.Trim()+"-"+txtBusinessNum3.Text.Trim() },
                {"nvar_P_UNIQUE_NO","" },
                {"nvar_P_COMPANY_NAME",txtOrganName.Text.Trim() },
                {"nvar_P_COMPANY_CODE",compCode },
                {"nvar_P_ORDERSALECOMPANY_CODE",OrderSaleCompCode },
                {"nvar_P_DELEGATE_NAME",txtRepresentativeName.Text.Trim() },
                {"nvar_P_DEPTNAME",txtDeptName.Text.Trim() },
                {"nume_P_COMPANYAREA_CODE",0 },
                {"nvar_P_COMPBUSINESSDEPT_CODE","" },
                {"nvar_P_COMPANYDEPT_CODE","" },
                {"nvar_P_SABUN","" },
                {"nvar_P_POSITION",txtPostion.Text.Trim() },
                {"nvar_P_ENTERURLDOMAIN",domain },
                {"nvar_P_UPTAE", txtUptae.Text.AsText() }, //업태
                {"nvar_P_UPJONG",txtUpjong.Text.AsText() }, //업종

                // Delivery
                {"nvar_P_SVID_DELIVERY", createDeliveryId },
                {"nvar_P_ADMINUSERID", AdminUserId },
                {"nvar_P_FREECOMPYN", FreeCompYn },
                {"nvar_P_AUTOCONFIRMYN", AutoConfirmYN },
                {"reVa_P_RETURNVAL",0 },
            };
            returnVal = UserService.SaveUser(paramList);

            if (fuRegist.HasFile)
            {
                var createAttachId = Guid.NewGuid().ToString(); // 첨부파일 시퀀스 생성
                string fileName = fuRegist.FileName; //업로드될 파일명
                string ext = Path.GetExtension(this.fuRegist.PostedFile.FileName); //확장자
                int fileSize = fuRegist.PostedFile.ContentLength; //업로드될 파일 크기
                UserDocSave(createUserId, 1, 1, createAttachId);
                AttachFileSave(fileName, fileSize, createUserId, createAttachId, 1, ext); // Attach DB저장 및 파일업로드
                AttachFileUpload();
            }
        }
        catch (Exception ex)
        {
            logger.Error(ex, "ErrorMessage");
            throw;
        }

        var useSMS = ConfigurationManager.AppSettings["SendSMSUse"].AsText("false");
        if (returnVal == 2)
        {

            if (useSMS == "true")
            {
                SendMMS("USERB", "manual");
            }

            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('회원가입이 완료되었습니다. 관리자의 승인절차가 필요합니다.'); window.location='../Default.aspx';</script>");
        }
        else if (returnVal == 1)
        {
            if (useSMS == "true")
            {
                SendMMS("USERA", "auto");
            }

            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('회원가입이 완료되었습니다.'); window.location='../Default.aspx';</script>");
        }
    }
}