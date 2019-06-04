using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Board;
using SocialWith.Biz.User;
using Urian.Core;

public partial class AdminSub_Member_DocumentManager : AdminSubPageBase
{
    UserService userService = new UserService();
    protected BoardService BoardService = new BoardService();

    protected void Page_Init(object sender, EventArgs e)
    {
        this.Form.Enctype = "multipart/form-data";
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();

        if (IsPostBack == false)
        {
            DefaultDataBind();
        }
    }

    #region <<파라미터 Get>>
    protected void ParseRequestParameters()
    {
    }

    #endregion

    #region <<데이터바인드>>
    protected void DefaultDataBind()
    {
        GetUserDocList();
    }

    protected void GetUserDocList() {

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", Svid_User },
        
        };

        var list = userService.GetUserDocList(paramList);

        lvDocList.DataSource = list;
        lvDocList.DataBind();
    }

    #endregion

    #region <<이벤트>>

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
        GetUserDocList();
    }

    protected void lvDocList_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {

    }

    protected void btnConfirm_Click(object sender, EventArgs e)
    {
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
                string iFileName = "D" + "_" + UserInfoObject.Id + "_" + docIndex + "_" + fileName; //논리파일명


                UserDocSave(Svid_User, docIndex, channel.AsInt(), type.AsInt(), createAttachId);//유저문서함 저장
                AttachFileSave(fileName, fileSize, Svid_User, createAttachId, docIndex, ext); // 파일DB저장


                string strFilePath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
                AttachFileUpload(postedFile, fileName, strFilePath); //실제 파일 업로드
                docIndex++;
            }
        }
        GetUserDocList();
    }

    public void UserDocSave(string svidUser, int docIndex, int channel, int type, string createAttachId)
    {
        var createDocId = Guid.NewGuid().ToString();

        var paramList = new Dictionary<string, object>
        {
                { "nvar_P_SVID_DOC", createDocId},
                { "nvar_P_SVID_USER", svidUser},
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
        string iFileName = "D" + "_" + UserInfoObject.Id + "_" + docIndex + "_" + uploadFileName; //논리파일명
        string filePath = "\\Member\\" + "A" + "\\" + UserInfoObject.Id + "\\";
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
        FileHelper.MuiltiFileUpload(postedFile, this.Page, fileName, maxSize, UserInfoObject.Id, "MemberA", UserInfoObject.Id); // 파일 업로드
    }
    #endregion




    
}