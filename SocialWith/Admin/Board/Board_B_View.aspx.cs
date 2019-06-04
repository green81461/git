using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.User;
using Urian.Core;

public partial class Admin_Board_Board_B_View : AdminPageBase
{
    protected string Svid;
    protected string Ucode;
    protected SocialWith.Biz.Board.BoardService BoardService = new SocialWith.Biz.Board.BoardService();
    protected SocialWith.Biz.Comm.CommService CommService = new SocialWith.Biz.Comm.CommService();
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
        Ucode = Request.QueryString["ucode"].ToString();
    }

    protected void BoardBind()
    {
        lblAdmin.Text = UserInfoObject.Name;
        lblResultEntryDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_SVID_BOARD", Svid }
        };

        var board = BoardService.GetBoard(paramList);

        if (board != null)
        {
            
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
                lblResultEntryDate.Text = board.Board_Result.Result_RegDate.ToString("yyyy-MM-dd");
                txtReply.Text = board.Board_Result.Result_Memo;
                hdSvidBoardResult.Value = board.Board_Result.Svid_Result;
            }
            ddlResultStatus.SelectedValue = board.Board_Detail.Result_Status;
          
        }
    }

    //commType get
    protected string GetComm(string code, int channel, int type)
    {

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
    
    private void SendMMS()
    {


        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_TYPE", "BOARD"},
        };
        var userService = new UserService();
        var list = userService.GetSMSUserList(paramList);

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
                    {"nvar_P_SUBJECT", "[고객사 B - 상품 (답변완료)]"},
                    {"nvar_P_DEST_INFO", incomingUser.Substring(0, incomingUser.Length-1)},
                    //{"nvar_P_SMS_MSG",  "[주문의 건]\r\n"+ Request.Params["MOID"].AsText()+"(" + Request.Params["Amt"].AsDecimal().ToString("N0") + "원)"},
                    {"nvar_P_MSG",  "[고객사 B - 상품 (답변완료)]\r\n회사명 : " + lblCompanyNmHeader.Text.Trim() +"\r\n작성자 : " + lblWrite.Text.Trim() + "\r\n제목 : " + lblTitle.Text.Trim() + "\r\n 건 1:1 문의에 답변이 완료되었습니다. \r\n검토 바랍니다." },
                };

                userService.MMSInsert(paramList2);
            }

        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        var createId = string.Empty;

        if (!string.IsNullOrWhiteSpace(hdSvidBoardResult.Value))
        {
            createId = hdSvidBoardResult.Value;
        }
        else
        {
            createId = Guid.NewGuid().ToString();
        }
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SVID_RESULT", createId},
            { "nvar_P_SVID_BOARD", Svid},
            { "nvar_P_SVID_USER", Svid_User},
            { "nvar_P_RESULT_MEMO", txtReply.Text.Trim()},
            { "nvar_P_RESULT_STATUS", ddlResultStatus.Text.Trim()},
        };

        BoardService.InsertBoardReply(paramList);


        if (ddlResultStatus.SelectedValue == "Y")
        {
            SendMMS();
        }
        Response.Redirect("Board_B.aspx?ucode=" + Ucode);
    }
}