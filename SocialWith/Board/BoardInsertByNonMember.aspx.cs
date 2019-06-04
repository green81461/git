using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;

public partial class Board_BoardInsertByNonMember : NonAuthenticationPageBase
{
    protected SocialWith.Biz.Board.BoardService Service = new SocialWith.Biz.Board.BoardService();
    protected SocialWith.Biz.Comm.CommService CommService = new SocialWith.Biz.Comm.CommService();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack == false)
        {

            GetCommList();
        }
    }

    //DB의 값을 바인딩.
    protected void GetCommList()
    {

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

    //protected void BoardBind()
    //{

    //    var service = new SocialWith.Biz.Board.BoardService();
    //    var paramList = new Dictionary<string, object> {
    //        {"nvar_P_SVID_BOARD", Svid },
    //     };
    //    var board = service.GetBoard(paramList);
    //    if (board != null)
    //    {
    //        lblTitle.Text = board.Board_Title;
    //        lblWriter.Text = board.Board_Write;
    //        lblRegDate.Text = board.Board_RegDate.ToString("yyyy-MM-dd hh:mm:ss");
    //        txtContent.Text = board.Board_Detail.Context;
    //    }
    //}ㅋ

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string createAttachId = string.Empty;
        var service = new SocialWith.Biz.Board.BoardService();

        if (fuBoard.HasFile)
        {
            createAttachId = Guid.NewGuid().ToString(); //파일seq 생성
        }

        var createBoardId = Guid.NewGuid().ToString();
        var createUserId = Guid.NewGuid();
        var paramList = new Dictionary<string, object>  {

            {"nvar_P_SVID_BOARD",createBoardId },
            {"nvar_P_BOARD_USER","" },
            {"nvar_P_BOARD_WRITE",txtBoardWrite.Text.Trim() },
            {"nvar_P_COMPANY_NAME",txtCompanyName.Text.Trim() },
            {"nume_P_BOARD_GUBUN", 2 },
            {"nvar_P_BOARD_TITLE", txtTitle.Text.Trim() },
            {"nume_P_BOARD_CHANEL", ddlComm.SelectedValue.Split('_')[0] },
            {"char_P_BOARD_TYPE",ddlComm.SelectedValue.Split('_')[1] },
            {"char_P_DELFLAG","N" },
           // {"char_P_ATTCHFLAG", "N"},
            {"nume_P_READCOUNT",0 },
            {"nvar_P_PWD",Crypt.MD5Encryption(txtPwd.Text.Trim())},
           // {"nvar_P_PWD",txtPwd.Text.Trim()},
            {"reVa_P_RETURN_BOARDNO",0 },


            //Detail
            //{"nvar_P_SVID_ATTACH",createAttachId },
            {"nvar_P_CONTEXT",Server.UrlDecode(hfContent.Value.Trim())},
            {"nvar_P_TELNO",ddlTelPhone.SelectedValue.Trim() +"-" + txtTelPhone2.Text.Trim() + "-" + txtTelPhone3.Text.Trim() },
            {"nvar_P_PHONENO",Crypt.AESEncrypt256(ddlSelPhone.SelectedValue.Trim() + "-" + txtSelPhone2.Text.Trim() + "-" + txtSelPhone3.Text.Trim()) },
            {"nvar_P_EMAIL",Crypt.AESEncrypt256(txtEmail1.Text.Trim() + "@" + txtEmail2.Text.Trim()) },
            {"nvar_P_IP","127.0.0.1" },
            {"nvar_P_RESULT_STATUS","N" }



         };
        int boardNum = Service.SaveBoardReturnValue(paramList);
        if (fuBoard.HasFile)
        {
            createAttachId = Guid.NewGuid().ToString(); //파일seq 생성
            AttachFileSave(createBoardId, createAttachId, boardNum); // Attach DB저장 및 파일업로드
        }
        Response.Redirect("BoardList.aspx");
    }

    public void AttachFileSave(string svid, string attachSeq, int boardNo)
    {
        string fileName = fuBoard.FileName; //업로드될 파일명
        int fileSize = fuBoard.PostedFile.ContentLength; //업로드될 파일 크기
        string ext = Path.GetExtension(this.fuBoard.PostedFile.FileName); //확장자
        string strFilePath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
        string filePath = "\\Board\\" + "NoId" + "\\" + boardNo + "\\";
        string iFileName = "B" + "_" + boardNo + "_" + fileName; //논리파일명
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
        //FileHelper.FileUpload(fuBoard, fileName, filePath, maxSize); // 파일 업로드
        FileHelper.FileUpload(fuBoard, this.Page, fileName, maxSize, "NoId", "Board", boardNo.AsText()); // 파일 업로드
    }
}