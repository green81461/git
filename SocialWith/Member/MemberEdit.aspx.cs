using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.User;
using Urian.Core;

public partial class Member_MemberEdit : PageBase
{

    protected int docCnt = 0; //증빙서류 개수

    protected SocialWith.Biz.User.UserService userService = new SocialWith.Biz.User.UserService();
    protected SocialWith.Biz.Board.BoardService BoardService = new SocialWith.Biz.Board.BoardService();

    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string siteType = ConfigurationManager.AppSettings["SiteType"].AsText();
        string settingDistCssCode = ConfigurationManager.AppSettings["SettingDistCssCode"].AsText();//개발자용 배포코드
        string distCode = "DS00000002"; //기본 사이트배포코드값

        if (siteType == "Localhost")//Webconfig의 SiteType가 Localhost(개발자용)이면 Webconfig의 SettingDistCssCode의값을 갖고온다
        {
            distCode = settingDistCssCode;
        }
        else if (DistCssObject != null) //Webconfig의 SiteType가 Localhost(개발자용)가 아니고 DistCssObject가 널이 아니면 DistCssObject의 코드값을 갖고온다
        {
            distCode = DistCssObject.DistCssCode.AsText("DS00000002"); //사이트배포 데이터가 있으면 해당 코드를 갖고온다

        }
        string masterPageUrl = "~/UploadFile/SiteManagement/" + distCode + "/Main/Default.master"; //마스터페이지 분기처리(해당코드경로의 마스터페이지를 갖고옴)
        this.MasterPageFile = masterPageUrl;

    }

    protected void Page_Init(object sender, EventArgs e)
    {
        this.Form.Enctype = "multipart/form-data";
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack == false)
        {
            GetUserInfo();
        }
    }
    
    public void GetUserInfo() {

        var service = new UserService();
        var paramList = new Dictionary<string, object>() {
            {"nvar_P_ID", UserId}
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
            txtUptae.Text = user.UserInfo.Uptae; //업태
            txtUpjong.Text = user.UserInfo.Upjong; //업종

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
        GetUserDocList(user.Svid_User); //증빙서류 조회
    }
    //protected void btnOk_Click(object sender, EventArgs e)
    //{
    //    var service = new UserService();
    //    var svid_User = HttpContext.Current.Session["Svid_User"].ToString();
    //    var smsAllowFlag = 'N';
    //    if (rbSMSAlllowY.Checked == true)
    //    {
    //        smsAllowFlag = 'Y';
    //    }
    //    else
    //    {
    //        smsAllowFlag = 'N';
    //    }

    //    var emailAllowFlag = 'N';
    //    if (rbEmailAlllowY.Checked == true)
    //    {
    //        emailAllowFlag = 'Y';
    //    }
    //    else
    //    {
    //        emailAllowFlag = 'N';
    //    }
        
    //    var paramList = new Dictionary<string, object>{
    //        {"nvar_P_SVID_USER",svid_User},
    //        {"nvar_P_PWD",Crypt.MD5Encryption(txtPwd.Text.Trim())},
    //        {"nvar_P_NAME",txtPerson.Text.Trim()},
    //        {"nvar_P_POSITION",txtPos.Text.Trim()},
    //        {"nvar_P_EMAIL",Crypt.AESEncrypt256(txtFirstEmail.Text.Trim() + "@" + txtLastEmail.Text.Trim())},
    //        {"nvar_P_PHONENO", Crypt.AESEncrypt256(txtSelPhone.Text.Trim())},
    //        {"nvar_P_SMSYN", smsAllowFlag},
    //        {"nvar_P_EMAILYN", emailAllowFlag},
    //        {"nvar_P_UPTAE", txtUptae.Text.AsText()},
    //        {"nvar_P_UPJONG", txtUpjong.Text.AsText()},
    //        {"nvar_P_TELNO", txtTelNo.Text.Trim()},
    //        {"nvar_P_FAXNO", txtFaxNo.Text.Trim()}
    //    };
    //    service.UpdateUserInfo(paramList);

    //    int docIndex = 1;
    //    string[] fieldNames = Request.Files.AllKeys;

    //    for (int i = 0; i < Request.Files.Count; i++)
    //    {

    //        HttpPostedFile postedFile = Request.Files[i];
    //        if (postedFile.ContentLength > 0)
    //        {
                
    //            string fileName = Path.GetFileName(postedFile.FileName);//파일명
    //            string ext = Path.GetExtension(postedFile.FileName); //확장자
    //            int fileSize = postedFile.ContentLength;//파일크기
    //            var createAttachId = Guid.NewGuid().ToString(); //첨부파일 시퀀스생성

    //            var channel = string.Empty;
    //            var type = string.Empty;
    //            if (!string.IsNullOrWhiteSpace(fieldNames[i]))
    //            {
    //                channel = fieldNames[i].Substring(fieldNames[i].Length - 3, 3).Split('_')[0]; //업로드파일 채널 갖고오기
    //                type = fieldNames[i].Substring(fieldNames[i].Length - 3, 3).Split('_')[1]; //업로드파일 타입 갖고오기
    //            }
    //            string iFileName = "D" + "_" + UserId + "_" + docIndex + "_" + fileName; //논리파일명


    //            UserDocSave(Svid_User, docIndex, channel.AsInt(), type.AsInt(), createAttachId);//유저문서함 저장
    //            AttachFileSave(fileName, fileSize, Svid_User, createAttachId, docIndex, ext); // 파일DB저장


    //            string strFilePath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
    //            AttachFileUpload(postedFile, fileName, strFilePath); //실제 파일 업로드
    //            docIndex++;
    //        }
    //    }

    //    Response.Redirect("~/Default.aspx");
    //}

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

    public void UserDocSave(string createUserId, int docIndex, int channel, int type, string createAttachId)
    {
        var createDocId = Guid.NewGuid().ToString();

        var paramList = new Dictionary<string, object>
        {
                { "nvar_P_SVID_DOC", createDocId},
                { "nvar_P_SVID_USER", createUserId},
                { "nume_P_DOC_NO", docIndex },
                { "nvar_P_MAP_CODE","MEMBER" },
                { "nume_P_COMM_TYPE",type },
                { "nume_P_COMM_CHANNEL", channel},
                { "nvar_P_SVID_ATTACH",createAttachId },
        };

        userService.SaveUserDoc(paramList);

    }

    public void AttachFileSave(string uploadFileName, int fileSize, string svid, string attachSeq, int docIndex, string ext)
    {
        string iFileName = "D" + "_" + UserId + "_" + docIndex + "_" + uploadFileName; //논리파일명
        string filePath = "\\Member\\" + "B" + "\\" + UserId + "\\";
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

    public void AttachFileUpload(HttpPostedFile postedFile, string fileName, string filePath)
    {
        int maxSize = int.Parse(ConfigurationManager.AppSettings["UploadFileMaxSize"]);
        FileHelper.MuiltiFileUpload(postedFile, this.Page, fileName, maxSize, UserId, "MemberB", UserId); // 파일 업로드
    }
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
        else if (e.CommandName == "delete")
        {

            //데이터 삭제 시작
            var svidDoc = e.CommandArgument.AsText();
            var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_DOC", svidDoc },

            };
            userService.DeleteUserDoc(paramList);

            //데이터 삭제 끝

            //파일 삭제 시작
            var lbAttachFileName = (LinkButton)e.Item.FindControl("lbAttachFileName");
            var hfPath = (HiddenField)e.Item.FindControl("hfPath");
            if (lbAttachFileName != null && hfPath != null)
            {
                var fullPath = uploadFolderServerPath + hfPath.Value + lbAttachFileName.Text;
                FileHelper.FileDelete(fullPath);
            }
            //파일 삭제 끝

            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "<script>alert('삭제되었습니다.');</script>");


        }
        GetUserDocList(Svid_User);
    }
    #endregion

    protected void lvDocList_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {

    }

    protected void btnOk_Click(object sender, EventArgs e)
    {
        var service = new UserService();
        var svid_User = Request.Cookies["Svid_User"].Value.ToString();
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
            {"nvar_P_PHONENO", Crypt.AESEncrypt256(txtSelPhone.Text.Trim())},
            {"nvar_P_SMSYN", smsAllowFlag},
            {"nvar_P_EMAILYN", emailAllowFlag},
            {"nvar_P_UPTAE", txtUptae.Text.AsText()},
            {"nvar_P_UPJONG", txtUpjong.Text.AsText()},
            {"nvar_P_TELNO", txtTelNo.Text.Trim()},
            {"nvar_P_FAXNO", txtFaxNo.Text.Trim()}
        };
        service.UpdateUserInfo(paramList);

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
                string iFileName = "D" + "_" + UserId + "_" + docIndex + "_" + fileName; //논리파일명


                UserDocSave(Svid_User, docIndex, channel.AsInt(), type.AsInt(), createAttachId);//유저문서함 저장
                AttachFileSave(fileName, fileSize, Svid_User, createAttachId, docIndex, ext); // 파일DB저장


                string strFilePath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
                AttachFileUpload(postedFile, fileName, strFilePath); //실제 파일 업로드
                docIndex++;
            }
        }

        Response.Redirect("~/Default.aspx");
    }
}