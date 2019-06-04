﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Web.UI.WebControls;
using Urian.Core;

public partial class Board_BoardInsertByMember : PageBase
{
    protected SocialWith.Biz.Board.BoardService BoardService = new SocialWith.Biz.Board.BoardService();
    protected SocialWith.Biz.User.UserService UserService = new SocialWith.Biz.User.UserService();
    protected SocialWith.Biz.Comm.CommService CommService = new SocialWith.Biz.Comm.CommService();
    //protected SocialWith.Biz.
    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack == false)
        {
            GetUserInfo();
            GetCommList();
        }
    }

    private void GetUserInfo()
    {
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_ID", UserId},  //로그인 session값 추가
        };


        var user = UserService.GetUser(paramList); //userservice로 user정보 갖고옴 
        if (user != null)
        {
            lblWrite.Text = user.Name;           
            lblPhone.Text = !string.IsNullOrWhiteSpace(user.PhoneNo) ?  Crypt.AESDecrypt256(user.PhoneNo) : string.Empty; 
            lblMail.Text = !string.IsNullOrWhiteSpace(user.Email) ? Crypt.AESDecrypt256(user.Email) : string.Empty; 
            hfSvidUser.Value = user.Svid_User;
            if (user.UserInfo != null)
            {
                hfCompanyName.Value = user.UserInfo.Company_Name;
                
            }
            hfTelNum.Value = user.TelNo;
            hfPhoneNum.Value = user.PhoneNo;

            hfEmail.Value = user.Email;
            hfpwd.Value = user.Pwd;

        }
    }

    protected void GetCommList() {

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPCODE", "BOARD"},
            { "nume_P_MAPCHANEL", 1},
        };

        var list = CommService.GetCommList(paramList);

        if ((list != null) && (list.Count > 0))
        {
            foreach (var item in list)
            {
                if (item.Map_Type != 0)
                {
                    ddlComm.Items.Add(new ListItem(item.Map_Name, item.Map_Channel + "_" + item.Map_Type));
                }
            }
        }
    }
    

    public void AttachFileSave(string svid, string attachSeq, int boardNo)
    {

        string fileName = fuUploadFile.FileName; //업로드될 파일명
        int fileSize = fuUploadFile.PostedFile.ContentLength; //업로드될 파일 크기
        string ext = Path.GetExtension(this.fuUploadFile.PostedFile.FileName); //확장자
        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"];
        // string strFilePath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
        string filePath = "\\Board\\" + UserId + "\\" + boardNo + "\\";
        string iFileName = "B"+ UserId + "_" + boardNo + "_" + fileName; //논리파일명
        // string iFileName = UserId + "_" + boardNo + "_" + fileName; //논리파일명
        var paramList = new Dictionary<string, object>
        {
            //첨부파일
            {"nvar_P_SVID_ATTACH", attachSeq},
            {"nvar_P_SVID_BOARD", svid},
            {"nume_P_ATTACH_NO", 1 },
            {"nvar_P_ATTACH_P_NAME",fileName },
            {"nvar_P_ATTACH_I_NAME",iFileName },
            {"nvar_P_ATTACH_EXT", ext},
            {"nume_P_ATTACH_DOWNCNT",0 },
            {"nvar_P_ATTACH_SIZE", fileSize },
            {"nvar_P_ATTACH_PATH", filePath }
        };
        AttachFileUpload(fileName, boardNo); //실제 파일 업로드
        BoardService.SaveBoardAttach(paramList);       //파일 DB 저장
    }

    public void AttachFileUpload(string fileName, int boardNo)
    {
        int maxSize = int.Parse(ConfigurationManager.AppSettings["UploadFileMaxSize"]);
        FileHelper.FileUpload(fuUploadFile, this.Page, fileName, maxSize, UserId, "Board", boardNo.AsText()); // 파일 업로드
    }

    private void SendMMS()
    {


        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_TYPE", "BOARD"},
        };

        var list = UserService.GetSMSUserList(paramList);

        if (list != null)
        {
            string incomingUser = string.Empty;

            foreach (var item in list)
            {
                incomingUser += item.Name + "^" + Crypt.AESDecrypt256(item.PhoneNo).Replace("-", "") + "|";
            }

            if (!string.IsNullOrWhiteSpace(incomingUser))
            {
                var paramList2 = new Dictionary<string, object>
                {
                    {"nvar_P_SUBJECT", "[고객사 B - 상품 (문의)]"},
                    {"nvar_P_DEST_INFO", incomingUser.Substring(0, incomingUser.Length-1)},
                    //{"nvar_P_SMS_MSG",  "[주문의 건]\r\n"+ Request.Params["MOID"].AsText()+"(" + Request.Params["Amt"].AsDecimal().ToString("N0") + "원)"},
                    {"nvar_P_MSG",  "[고객사 B - 상품 (문의)]\r\n회사명 : " + UserInfoObject.UserInfo.Company_Name +"\r\n작성자 : " + UserInfoObject.Name + "\r\n제목 : " + txtTitle.Text.Trim() + "\r\n 건 1:1 문의가 등록되었습니다. \r\n확인 후 답변 작성 해주시기 바랍니다." },
                };

                UserService.MMSInsert(paramList2);
            }

        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string strFile = string.Empty;
        string createAttachId = string.Empty;
        string ext = string.Empty;

        try
        {
            var createBoardId = Guid.NewGuid().ToString(); //코드생성
            var createUserId = Guid.NewGuid().ToString();
            var paramList = new Dictionary<string, object> {

            //리스트
            {"nvar_P_SVID_BOARD",createBoardId },
            {"nvar_P_BOARD_USER", hfSvidUser.Value.Trim() },
            {"nvar_P_BOARD_WRITE", lblWrite.Text},
            {"nvar_P_COMPANY_NAME",hfCompanyName.Value.Trim() },
            {"nume_P_BOARD_GUBUN", 2 },
            {"nvar_P_BOARD_TITLE", txtTitle.Text.Trim() },
            {"nume_P_BOARD_CHANEL", ddlComm.SelectedValue.Split('_')[0] },
            {"char_P_BOARD_TYPE",ddlComm.SelectedValue.Split('_')[1] },
            {"char_P_DELFLAG","N" },
            {"nume_P_READCOUNT",0 },
            {"nvar_P_PWD", ""},
            {"reVa_P_RETURN_BOARDNO",0 },

            //Detail
            {"nvar_P_CONTEXT",Server.UrlDecode(hfContent.Value.Trim()) },
            {"nvar_P_TELNO",hfTelNum.Value.Trim() },
            {"nvar_P_PHONENO",hfPhoneNum.Value.Trim() },
            {"nvar_P_EMAIL",hfEmail.Value.Trim() },
            {"nvar_P_IP","127.0.0.1" },
            {"nvar_P_RESULT_STATUS","N" }

         };

            int boardNum = BoardService.SaveBoardReturnValue(paramList); //파일 저장을 위해 boardnum을 리턴
            if (fuUploadFile.HasFile)
            {
                createAttachId = Guid.NewGuid().ToString(); //파일seq 생성
                AttachFileSave(createBoardId, createAttachId, boardNum); // Attach DB저장 및 파일업로드
            }
            SendMMS();//문자 전송
        }
        catch (Exception ex)
        {
            logger.Error(ex, "ErrorMessage");
        }
        Response.Redirect("BoardList.aspx", false);
    }
}