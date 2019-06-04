using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Data.Board;

public partial class Notice_NoticeView : PageBase
{
    protected string Svid;
    protected SocialWith.Biz.Board.BoardService BoardService = new SocialWith.Biz.Board.BoardService();

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
            BoardBind();
        }
    }

    protected void ParseRequestParameters()
    {
        Svid = Request.QueryString["Svid"].ToString();
    }

    protected void BoardBind() {

         var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_BOARD", Svid },
         };

        var board = BoardService.GetBoard(paramList);

       
        if (board != null && board.Svid_Board != null)
        {
            string writer = board.Board_Write;

            ReadCountUpdate(); // 조회수 업데이트

            lblTitle.Text = board.Board_Title;
            lblWriter.Text = board.Board_Write;
            lblRegDate.Text = board.Board_RegDate.ToString("yyyy-MM-dd hh:mm:ss");
            lblContent.Text = board.Board_Detail.Context.Replace("\r\n", "<br>");

            var attachParamList = new Dictionary<string, object>
                {
                    { "nvar_P_SVID_BOARD", board.Svid_Board },
                };

            var attachList = BoardService.GetBoardAttachList(attachParamList); //파일리스트 가져와서 
            if (attachList.Count > 0)
            {
                lbFileDown.Text = attachList.FirstOrDefault().Attach_P_Name; //링크버튼에 바인딩

                hfFilePath.Value = attachList.FirstOrDefault().Attach_Path;
                hfFileName.Value = attachList.FirstOrDefault().Attach_P_Name;
            }

        }
    }

    //조회수 업데이트
    protected void ReadCountUpdate()
    {
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_BOARD", Svid },
         };
        BoardService.UpdateBoardReadCount(paramList);
    }

    //파일 다운로드 카운트 업데이트
    protected void AttachDownCountUpdate()
    {
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_BOARD", Svid },
         };
        BoardService.UpdateBoardAttachCount(paramList);
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_BOARD", Svid },
         };
        BoardService.DeleteBoard(paramList);
        Response.Redirect("NoticeList.aspx");
    }

    protected void lbFileDown_Click(object sender, EventArgs e)
    {
        string fileName = string.Empty;
        string uploadFolderServerPath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
        string fileFullPath = string.Empty;
        if (!String.IsNullOrEmpty(hfFileName.Value) && !String.IsNullOrEmpty(hfFilePath.Value))
        {

            fileFullPath = uploadFolderServerPath + hfFilePath.Value + hfFileName.Value;

            FileHelper.FileDownload(this.Page, fileFullPath, hfFileName.Value);
            AttachDownCountUpdate();
        }

        //AttachDownCountUpdate();
    }
}