using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;

public partial class Admin_Member_MemberCreate_R : LoginPageBase
{
    protected SocialWith.Biz.User.UserService UserService = new SocialWith.Biz.User.UserService();
    protected SocialWith.Biz.Board.BoardService BoardService = new SocialWith.Biz.Board.BoardService();

    protected void Page_Init(object sender, EventArgs e)
    {
        this.Form.Enctype = "multipart/form-data";
    }

    protected void Page_Load(object sender, EventArgs e)
    {
     
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            var siteName = string.Empty;
            string url = HttpContext.Current.Request.Url.Host;
            if (url.Trim().StartsWith("www"))
            {
                siteName = url.Trim().Split('.')[1];
            }
            else
            {
                siteName = url.Trim().Split('.')[0];
            }
            var createUserId = Guid.NewGuid().ToString();
            var createDeliveryId = Guid.NewGuid().ToString();
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

            var paramList = new Dictionary<string, object> {
            

            //리스트
            {"nvar_P_SITENAME", siteName},
            {"nvar_P_SVID_USER",createUserId },
            {"nvar_P_NAME",txtChargeName.Text.Trim() },
            {"nvar_P_ID", txtId.Text.Trim()},
            {"nvar_P_PWD",Crypt.MD5Encryption(txtPwd.Text.Trim() )}, //비밀번호 암호화
            {"nvar_P_TELNO", txtTelPhone.Text.Trim()},
            {"nvar_P_PHONENO", Crypt.AESEncrypt256(txtSelPhone.Text.Trim())}, //폰번호 암호화
            {"nvar_P_FAXNO", txtFax.Text.Trim()},
            {"nvar_P_EMAIL",Crypt.AESEncrypt256(txtEmail1.Text.Trim() + "@" + txtEmail2.Text.Trim())},//이메일 암호화
            {"nvar_P_GUBUN","IU" },
            {"nvar_P_COMPGUBUN","IU" },
            {"nvar_P_SVID_ROLE","A1" },  //나중에 협의
            {"char_P_CONFIRMFLAG","N" },
            {"nvar_P_PRICERULE","0" },
            {"nvar_P_SMSYN", smsAllowFlag},
            {"nvar_P_EMAILYN", emailAllowFlag},
            {"nume_P_LOGINCOUNT",0 },
            {"char_P_LOGINCHECK","N" },
            {"char_P_DELFLAG","N" },

            //Info
            {"char_P_ZIPCODE",hfPostalCode.Value.Trim() }, //readonly textbox는 값을 못갖고 오기에 히든필드에 저장 
            {"nvar_P_ADDRESS_1",hfAddress1.Value.Trim() }, //readonly textbox는 값을 못갖고 오기에 히든필드에 저장
            {"nvar_P_ADDRESS_2",txtAddress2.Text.Trim()},
            {"nvar_P_COMPANY_NO",txtBusinessNum1.Text.Trim() +"-"+txtBusinessNum2.Text.Trim()+"-"+txtBusinessNum3.Text.Trim() },
            {"nvar_P_UNIQUE_NO","" },
            {"nvar_P_COMPANY_NAME",txtOrganName.Text.Trim() },
            {"nvar_P_COMPANY_CODE","" },
            {"nvar_P_ORDERSALECOMPANY_CODE","" },
            {"nvar_P_DELEGATE_NAME",txtRepresentativeName.Text.Trim() },
            {"nvar_P_DEPTNAME",txtDeptName.Text.Trim() },
            {"nume_P_COMPANYAREA_CODE",0 },
            {"nvar_P_COMPBUSINESSDEPT_CODE","" },
            {"nvar_P_COMPANYDEPT_CODE","" },
            {"nvar_P_SABUN","" },
            {"nvar_P_POSITION",txtPostion.Text.Trim() },
            {"nvar_P_ENTERURLDOMAIN",domain },
            {"nvar_P_UPTAE", "" }, //업태
            {"nvar_P_UPJONG","" }, //업종
            {"nvar_P_SVID_DELIVERY",createDeliveryId },// Delibery 
            {"nvar_P_ADMINUSERID","" },
            {"nvar_P_FREECOMPYN", "" },
            {"nvar_P_AUTOCONFIRMYN", "N" },
            {"reVa_P_RETURNVAL",0 }
            };

            UserService.SaveUser(paramList);
            int docIndex = 1;
            string[] fieldNames = Request.Files.AllKeys;

            for (int i = 0; i < Request.Files.Count; i++)
            {
              
                HttpPostedFile postedFile = Request.Files[i];
                if (postedFile.ContentLength > 0)
                {
                  
                    string fileName = Path.GetFileName(postedFile.FileName);//파일명
                    string ext = Path.GetExtension(postedFile.FileName); //확장자
                    int fileSize = postedFile.ContentLength;//파일크기
                    var createAttachId = Guid.NewGuid().ToString(); //첨부파일 시퀀스생성

                    var channel = string.Empty;
                    var type = string.Empty;

                    if (!string.IsNullOrWhiteSpace(fieldNames[i]))
                    {
                        channel = fieldNames[i].Substring(fieldNames[i].Length - 3, 3).Split('_')[0]; //업로드파일 채널 갖고오기
                        type = fieldNames[i].Substring(fieldNames[i].Length - 3, 3).Split('_')[1]; //업로드파일 타입 갖고오기
                    }
                    string iFileName = "D" + "_" + txtId.Text.Trim() + "_" + docIndex + "_" + fileName; //논리파일명


                    UserDocSave(createUserId, docIndex, channel.AsInt(), type.AsInt(), createAttachId);//유저문서함 저장
                    AttachFileSave(fileName, fileSize, createUserId, createAttachId, docIndex, ext); // 파일DB저장

                    
                    string strFilePath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
                    AttachFileUpload(postedFile, fileName, strFilePath); //실제 파일 업로드
                    docIndex++;
                }
            }
        }
        catch (Exception ex)
        {
            logger.Error(ex, "ErrorMessage");
        }
        //var useSMS = ConfigurationManager.AppSettings["SendSMSUse"].AsText("false");

        //if (useSMS == "true")
        //{
        //    SendMMS();
        //}
        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('회원가입이 완료되었습니다.'); window.location='MemberCreate_R.aspx?ucode=03';</script>");
        
    }
    public void UserDocSave(string createUserId, int docIndex, int channel,  int type, string createAttachId) {
        var createDocId = Guid.NewGuid().ToString();
       
        var paramList = new Dictionary<string, object>
        {
                { "nvar_P_SVID_DOC", createDocId},
                { "nvar_P_SVID_USER", createUserId},
                { "nume_P_DOC_NO", docIndex },
                { "nvar_P_MAP_CODE","MEMBER" },
                { "nume_P_COMM_TYPE",type },
                { "nume_P_COMM_CHANNEL", channel},
                { "nvar_P_SVID_ATTACH",createAttachId }
        };

        UserService.SaveUserDoc(paramList);
       
    }

    public void AttachFileSave(string uploadFileName,int fileSize,  string svid, string attachSeq, int docIndex ,string ext)
    {
        string iFileName = "D" + "_" + txtId.Text.Trim() + "_" + docIndex + "_" + uploadFileName; //논리파일명
        string filePath = "\\Member\\" + "A" + "\\" + txtId.Text.Trim() + "\\";
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

    public void AttachFileUpload(HttpPostedFile postedFile , string fileName, string filePath)
    {
        int maxSize = int.Parse(ConfigurationManager.AppSettings["UploadFileMaxSize"]);
        FileHelper.MuiltiFileUpload(postedFile, this.Page, fileName, maxSize, txtId.Text.Trim(), "MemberA", txtId.Text.Trim()); // 파일 업로드

        
    }

    //private void SendSMS()
    //{

    //    var paramList = new Dictionary<string, object>
    //    {
    //        {"nvar_P_TYPE", "USER"},
    //    };

    //    var list = UserService.GetSMSUserList(paramList);

    //    if (list != null)
    //    {
    //        string incomingUser = string.Empty;

    //        foreach (var item in list)
    //        {
    //            incomingUser += item.Name + "^" + Crypt.AESDecrypt256(item.PhoneNo).Replace("-", "") + "|";
    //        }
    //        if (!string.IsNullOrWhiteSpace(incomingUser))
    //        {
    //            var paramList2 = new Dictionary<string, object>
    //            {
    //                {"nvar_P_SUBJECT", "제목"},
    //                {"nvar_P_DEST_INFO", incomingUser.Substring(0, incomingUser.Length-1) },
    //                {"nvar_P_SMS_MSG", "[신규 가입의 건]\r\n판매사 1건(승인대기중)"},
    //            };

    //            UserService.SMSInsert(paramList2);
    //        }
            
    //    }
    //}

    //private void SendMMS()
    //{

    //    var paramList = new Dictionary<string, object>
    //    {
    //        {"nvar_P_TYPE", "USERA"},
    //    };

    //    var list = UserService.GetSMSUserList(paramList);

    //    if (list != null)
    //    {
    //        string incomingUser = string.Empty;

    //        foreach (var item in list)
    //        {
    //            incomingUser += item.Name + "^" + Crypt.AESDecrypt256(item.PhoneNo).Replace("-", "") + "|";
    //        }
    //        if (!string.IsNullOrWhiteSpace(incomingUser))
    //        {
    //            var paramList2 = new Dictionary<string, object>
    //            {
    //                {"nvar_P_SUBJECT", "[판매사 신규가입]"},
    //                {"nvar_P_DEST_INFO", incomingUser.Substring(0, incomingUser.Length-1) },
    //                {"nvar_P_MSG", "[판매사 신규가입]\r\n회사명 : " + txtOrganName.Text.Trim() + "\r\n아이디 : " + txtId.Text.Trim() + "\r\n\r\n" + "'승인 대기 중' 이니 검토 후 회원세팅 진행 바랍니다."},
    //            };

    //            UserService.MMSInsert(paramList2);
    //        }

    //    }
    //}
}