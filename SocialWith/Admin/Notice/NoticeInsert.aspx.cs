using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;
using SocialWith.Data.Board;

public partial class Admin_Notice_NoticeInsert : AdminPageBase
{
    protected SocialWith.Biz.Board.BoardService Service = new SocialWith.Biz.Board.BoardService();
    protected SocialWith.Biz.User.UserService UserService = new SocialWith.Biz.User.UserService();
    protected string Ucode;

    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
    }

    protected void ParseRequestParameters()
    {
        Ucode = Request.QueryString["ucode"].ToString();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        var userParamList = new Dictionary<string, object>
        {
            { "nvar_P_ID", AdminId},  //로그인 session값 추가
        };
        var user = UserService.GetUser(userParamList); //userservice로 user정보 갖고옴 

        string strFile = string.Empty;
        string createAttachId = string.Empty;
        string ext = string.Empty;

        var createBoardId = Guid.NewGuid().ToString();
        if (user != null)
        {
            var paramList = new Dictionary<string, object> {

            
                //리스트
                {"nvar_P_SVID_BOARD",createBoardId },
                {"nvar_P_BOARD_USER",user.Svid_User },
                {"nvar_P_BOARD_WRITE",user.Name },
                {"nvar_P_COMPANY_NAME",user.UserInfo.Company_Name },
                {"nume_P_BOARD_GUBUN", 13 },
                {"nvar_P_BOARD_TITLE", txtTitle.Text.Trim() },
                {"nume_P_BOARD_CHANEL",0 },
                {"char_P_BOARD_TYPE","0" },
                {"char_P_DELFLAG","N" },
                {"nume_P_READCOUNT",0 },
                {"nvar_P_PWD","" },
                {"reVa_P_RETURN_BOARDNO",0 },

                //Detail

                {"nvar_P_CONTEXT",Server.UrlDecode(hfContent.Value.Trim()) },
                //{"nvar_P_CONTEXT",txtContent.Text.Trim() },
                {"nvar_P_TELNO",user.TelNo.Trim() },
                {"nvar_P_PHONENO",user.PhoneNo },
                {"nvar_P_EMAIL",user.Email },
                {"nvar_P_IP","127.0.0.1" },
                {"nvar_P_RESULT_STATUS","N" }

             };

            int boardNum = Service.SaveBoardReturnValue(paramList); //파일 저장을 위해 boardnum을 리턴
            if (fuUploadFile.HasFile)
            {
                createAttachId = Guid.NewGuid().ToString(); //파일seq 생성
                AttachFileSave(createBoardId, createAttachId, boardNum); // Attach DB저장 및 파일업로드
            }

        }

        Response.Redirect("NoticeList.aspx?ucode="+Ucode, false);
    }

    public void AttachFileSave(string svid, string attachSeq, int boardNo) {

        string fileName = fuUploadFile.FileName; //업로드될 파일명
        int fileSize = fuUploadFile.PostedFile.ContentLength; //업로드될 파일 크기
        string ext = Path.GetExtension(this.fuUploadFile.PostedFile.FileName); //확장자
        string strFilePath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
        string filePath = "\\Notice\\" + AdminId + "\\" + boardNo + "\\";
        string iFileName = "B" + AdminId + "_" + boardNo + "_" + fileName; //논리파일명
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
        AttachFileUpload(fileName, strFilePath, boardNo); //실제 파일 업로드
        Service.SaveBoardAttach(paramList);       //파일 DB 저장
    }

    public void AttachFileUpload(string fileName, string filePath, int boardNo)
    {
        int maxSize = int.Parse(ConfigurationManager.AppSettings["UploadFileMaxSize"]);
        FileHelper.FileUpload(fuUploadFile, this.Page, fileName, maxSize, AdminId, "Notice", boardNo.AsText()); // 파일 업로드
    }

    
}