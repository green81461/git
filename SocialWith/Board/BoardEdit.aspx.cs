using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;

public partial class Board_BoardEdit : PageBase
{
    protected string Svid;
    protected SocialWith.Biz.Board.BoardService Service = new SocialWith.Biz.Board.BoardService();
    protected SocialWith.Biz.Comm.CommService CommService = new SocialWith.Biz.Comm.CommService();
    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ParseRequestParameters();
        if (IsPostBack == false)
        {
            GetCommList();
            BoardBind();

        }
    }


    protected void ParseRequestParameters()
    {
        Svid = Request.QueryString["Svid"].ToString();
    }

    protected void BoardBind()
    {

        var service = new SocialWith.Biz.Board.BoardService();
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_BOARD", Svid },
         };
        var board = service.GetBoard(paramList);
        if (board != null)
        {
            lblCompanyNm.Text = board.Company_Name;
            lblWrite.Text = board.Board_Write;

            //lblPwd.Text = board.PWD;
            ddlComm.SelectedValue = "1_" + board.Board_Type;


            if (board.Board_Detail != null)
            {
                lblTel.Text = board.Board_Detail.TelNum;
                lblPhoneNo.Text = Crypt.AESDecrypt256(board.Board_Detail.PhoneNum);
                lblEmail.Text = Crypt.AESDecrypt256(board.Board_Detail.Email);
            }

            txtTitle.Text = board.Board_Title;
            lblWriter.Text = board.Board_Write;
            lblRegDate.Text = board.Board_RegDate.ToString("yyyy-MM-dd hh:mm:ss");
            //txtContent.Text = board.Board_Detail.Context;
            hfContent.Value = board.Board_Detail.Context;
            if (board != null) // 업로드된 파일이 있으면...
            {
                var attachParamList = new Dictionary<string, object>
                {
                     {"nvar_P_SVID_BOARD", board.Svid_Board  },
                };

                var attachList = Service.GetBoardAttachList(attachParamList); //파일리스트 가져와서 
                hfBoardNo.Value = board.Board_No.ToString();//boardno 히든필드에 저장
                if (attachList.Count > 0)
                {
                    lbFileDown.Text = attachList.FirstOrDefault().Attach_P_Name; //링크버튼에 바인딩
                    fuUploadFile.Visible = false;
                    lbFileDown.Visible = true;
                    btnFileDelete.Visible = true;

                    hfFileName.Value = attachList.FirstOrDefault().Attach_I_Name;//파일Name 히든필드에 저장

                }
                else
                {
                    lbFileDown.Visible = false;
                    btnFileDelete.Visible = false;
                    fuUploadFile.Visible = true;
                    hfFileName.Value = "";

                }
            }
        }
    }

    
    protected void lbFileDown_Click(object sender, EventArgs e)
    {
        string fileName = string.Empty;
        string filePath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
        string fileFullPath = string.Empty;
        if (!String.IsNullOrEmpty(hfFileName.Value))
        {
            fileName = hfFileName.Value;
            fileFullPath = filePath + "\\" + fileName;

            FileHelper.FileDownload(this.Page, fileFullPath, fileName);
        }
    }


    public void AttachFileDelete(string svid, int attachNo)
    {
        var paramList = new Dictionary<string, object>
        {
            //첨부파일
            {"nvar_P_SVID_BOARD", svid},
            {"nume_P_ATTACHNO", attachNo},
        };
        Service.DeleteBoardAttach(paramList);
    }

    public void AttachFileSave(string svid, string attachSeq, int boardNo)
    {

        string fileName = fuUploadFile.FileName; //업로드될 파일명
        int fileSize = fuUploadFile.PostedFile.ContentLength; //업로드될 파일 크기
        string ext = Path.GetExtension(this.fuUploadFile.PostedFile.FileName); //확장자
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
        FileHelper.FileUpload(fuUploadFile, this.Page, fileName, maxSize, "NoId", "Board", boardNo.AsText()); // 파일 업로드
    }


    //protected void btnFileDelete_Click(object sender, ImageClickEventArgs e)
    //{

    //}

    protected void btnFileDelete_Click(object sender, ImageClickEventArgs e)
    {
        if (!String.IsNullOrEmpty(Svid))
        {

            AttachFileDelete(Svid, 1); //DB delete

            string fileName = string.Empty;
            string filePath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
            string fileFullPath = string.Empty;
            if (!String.IsNullOrEmpty(hfFileName.Value))
            {
                fileName = hfFileName.Value;
                fileFullPath = filePath + "\\" + fileName;

                File.Delete(fileFullPath); //실제 파일 delete
            }
            BoardBind();
        }
    }

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

    protected void btnEdit_Click(object sender, EventArgs e)
    {
        var service = new SocialWith.Biz.Board.BoardService();
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_BOARD", Svid },
            {"nvar_P_TITLE",txtTitle.Text.Trim()},
            {"nvar_P_CONTEXT",Server.UrlDecode(hfContent.Value.Trim()) },
              {"nvar_P_BOARDTYPE",ddlComm.SelectedValue.Split('_')[1]},
           // {"nvar_P_CONTEXT", txtContent.Text.Trim() },
         };
        service.UpdateBoard(paramList);

        if (fuUploadFile.HasFile && !String.IsNullOrEmpty(hfBoardNo.Value))
        {
            string createFileSeq = Guid.NewGuid().ToString();
            AttachFileSave(Svid, createFileSeq, int.Parse(hfBoardNo.Value));
        }
        Response.Redirect("BoardList.aspx");

    }
}