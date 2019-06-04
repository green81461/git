using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;
using SocialWith.Data.Board;

public partial class Board_BoardView : PageBase
{
    protected string Svid;
    protected SocialWith.Biz.Board.BoardService BoardService = new SocialWith.Biz.Board.BoardService();
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
            BoardBind();
        }
    }

    protected void ParseRequestParameters()
    {
        Svid = Request.QueryString["Svid"].ToString();
    }

    protected void BoardBind()
    {
        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_SVID_BOARD", Svid }
        };

        var board = BoardService.GetBoard(paramList);

        if (board != null)
        {
            string writer = board.Board_Write;
            string sessionId = Request.Cookies["LoginID"].Value.AsText();

            if (!String.IsNullOrWhiteSpace(sessionId))  //만약 회원일경우
            {
                if (writer.Equals(sessionId) == false) // 만약 작성자와 사용자 아이디가 같지 않다면..
                {
                    ReadCountUpdate(); // 조회수 업데이트
                }
            }
            else  //비회원일 경우 그냥 조회수 없데이트
            {
                ReadCountUpdate(); // 조회수 업데이트
            }
            

            lblCompanyNm.Text = board.Company_Name;
            lblWrite.Text = board.Board_Write;

            //lblPwd.Text = board.PWD;
            lblQueryGubun.Text = GetComm("BOARD", board.Board_Channel, board.Board_Type.AsInt()); // Comm가져옴
            lblTitle.Text = board.Board_Title;

                
            if (board.Board_Detail != null)
            {
                lblTel.Text = board.Board_Detail.TelNum;
                lblPhoneNo.Text = Crypt.AESDecrypt256(board.Board_Detail.PhoneNum);
                lblEmail.Text = Crypt.AESDecrypt256(board.Board_Detail.Email);
                lblContext.Text = ReplaceBR(board.Board_Detail.Context);
            }
            // 업로드 된 첨부파일이 있는 경우
            var attachParamList = new Dictionary<string, object>
            {
                {"nvar_P_SVID_BOARD", board.Svid_Board }
            };

            var attachList = BoardService.GetBoardAttachList(attachParamList); // 해당하는 파일 목록을 가져옴.
            if (attachList.Count > 0)
            {
                lbFileDown.Text = attachList.FirstOrDefault().Attach_P_Name; // 링크버튼에 바인딩

                hfFilePath.Value = attachList.FirstOrDefault().Attach_Path;
                hfFileName.Value = attachList.FirstOrDefault().Attach_P_Name;
            }


            if (!string.IsNullOrWhiteSpace(board.Board_Result.Svid_User))
            {
                lblAdmin.Text = board.Board_Result.AdminName;
                lblReplyDate.Text = board.Board_Result.Result_RegDate.ToString("yyyy-MM-dd");
                lblReply.Text = board.Board_Result.Result_Memo;
            }

         
            lblStatus.Text = SetResultStatusText(board.Board_Detail.Result_Status);
           
           
        }
    }

    protected string SetResultStatusText(string status) {
        string returnVal = string.Empty;

        if (status =="Y")
        {
            returnVal = "답변완료";
        }
        else
        {
            returnVal = "진행중";
        }

        return returnVal;
    }
    //commType get
    protected string GetComm(string code, int channel, int type) {

        string returnValue = string.Empty;

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPCODE", code},
            { "nume_P_MAPCHANEL", channel},
            { "nume_P_MAPTYPE", type},
        };

        var comm = CommService.GetComm(paramList);
        if (comm != null)
        {
            returnValue = comm.Map_Name.AsText();
        }

        return returnValue;
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

    // 내용 출력 시 '\n' 값을  '<BR>' 로 대체
    protected string ReplaceBR(string val)
    {
        return val.Replace("\n", "<BR>");
    }

    protected void lbFileDown_Click(object sender, EventArgs e)
    {
        string uploadFolderServerPath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
        string fileFullPath = string.Empty;
        if (!String.IsNullOrEmpty(hfFileName.Value) && !String.IsNullOrEmpty(hfFilePath.Value))
        {

            fileFullPath = uploadFolderServerPath + hfFilePath.Value + hfFileName.Value;

            FileHelper.FileDownload(this.Page, fileFullPath, hfFileName.Value);
            AttachDownCountUpdate();
        }
    }

    protected void ibtnDelete_Click(object sender, ImageClickEventArgs e)
    {
        
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_BOARD", Svid },
         };
        BoardService.DeleteBoard(paramList);
        Response.Redirect("BoardList.aspx");
    }
}