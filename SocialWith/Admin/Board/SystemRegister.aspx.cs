using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Board;
using SocialWith.Biz.Comm;
using SocialWith.Biz.SystemUpdate;
using SocialWith.Biz.User;

public partial class Admin_Board_SystemRegister : AdminPageBase
{
    CommService commService = new CommService();
    SystemUpdateService systemUpdateService = new SystemUpdateService();
    BoardService BoardService = new BoardService();
    protected string Ucode;
    protected void Page_Load(object sender, EventArgs e)
    {
        Ucode = Request.QueryString["ucode"].ToString();
        if (!IsPostBack)
        {
            DefaultDataBind();
        }
    }

    #region <<데이터바인드>>
    protected void DefaultDataBind()
    {
        txtDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        txtUser.Text = AdminId;
        GetCommList();
        GetCommView();
    }

    protected void GetCommList()
    {

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPCODE", "BOARD"},
            { "nume_P_MAPCHANEL", 2},
        };

        var list = commService.GetCommList(paramList);

        if (list.Count > 0)
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

    protected void GetCommView()
    {

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPTYPE", ddlComm.SelectedValue.Split('_')[1]},
        };

        var list = commService.GetCommSystemUpdateList(paramList);

        if (list.Count > 0)
        {
            foreach (var item in list)
            {
                if (item.Map_Type != 0)
                {
                    ddlView.Items.Add(new ListItem(item.Map_Name, item.Map_Channel + "_" + item.Map_Type));
                }
            }
        }

    }


    #endregion

    #region <<이벤트>>
    protected void ddlComm_Changed(object sender, EventArgs e)
    {
        ClearDdlCtgr(ddlView);
        int selectIdx = ddlComm.SelectedIndex;
      
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPTYPE", ddlComm.SelectedValue.Split('_')[1]},
        };

        var list = commService.GetCommSystemUpdateList(paramList);

        if ((list.Count > 0) && (list != null))
        {
            foreach (var item in list)
            {
                if (item.Map_Type != 0)
                {
                    ddlView.Items.Add(new ListItem(item.Map_Name, item.Map_Channel + "_" + item.Map_Type));
                }
            }
        }
      
    }

    // 카테고리 셀렉트박스 초기화
    protected void ClearDdlCtgr(DropDownList ddl)
    {
        ddl.Items.Clear();
        ddl.Text = string.Empty;     
    }

    // 저장버튼 클릭시
    protected void btnSave_Click(object sender, EventArgs e)
    {
        var code = StringValue.NextSystemUpdateCode();
        // txtTitle.Text = ddlView.SelectedValue;
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SYSTEMUPDATENO", code},
            { "nvar_P_SYSTEMUPDATE_TYPE", ddlComm.SelectedValue.Split('_')[1]},
            { "nvar_P_DISPLAYDESC", ddlView.SelectedValue.Split('_')[1]},
            { "nvar_P_TITLE", txtTitle.Text.Trim()},
            { "nvar_P_PROBLEM", txtProblemContent.Text.Trim()},
            { "nvar_P_REQUEST", txtReqContent.Text.Trim()},
            { "nvar_P_SVID_USER", Svid_User},
        };

        systemUpdateService.SaveSystemUpdate(paramList);
        SendMMS();
        var createAttachId1 = string.Empty;

        if (FileUpload1.HasFile)
        {
            createAttachId1 = Guid.NewGuid().ToString(); //파일seq 생성
        }

        if (FileUpload1.HasFile)
        {
            string filename = FileUpload1.FileName;
            int filesize = FileUpload1.PostedFile.ContentLength;
            AttachFileSave(createAttachId1, code, filename, filesize);
        }

        var createAttachId2 = string.Empty;

        if (FileUpload2.HasFile)
        {
            createAttachId2 = Guid.NewGuid().ToString(); //파일seq 생성
        }

        if (FileUpload2.HasFile)
        {
            string filename = FileUpload2.FileName;
            int filesize = FileUpload2.PostedFile.ContentLength;
            AttachFileSave(createAttachId2, code, filename, filesize);
        }

        var createAttachId3 = string.Empty;

        if (FileUpload3.HasFile)
        {
            createAttachId3 = Guid.NewGuid().ToString(); //파일seq 생성
        }

        if (FileUpload3.HasFile)
        {
            string filename = FileUpload3.FileName;
            int filesize = FileUpload3.PostedFile.ContentLength;
            AttachFileSave(createAttachId3, code, filename, filesize);
        }

        Response.Redirect("SystemListMain.aspx?ucode="+Ucode);
    }


    public void AttachFileSave(string attachSeq, string code, string filename, int filesize)
    {
        string fileName = filename; //업로드될 파일명
        int fileSize = filesize; //업로드될 파일 크기
        string ext = Path.GetExtension(filename); //확장자
        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"];
        string filePath = "\\System\\" + AdminId + "\\" + code + "\\";
        string iFileName = "B" + AdminId + "_" + code + "_" + fileName; //논리파일명
        var paramList = new Dictionary<string, object>
        {
            //첨부파일
            {"nvar_P_SVID_ATTACH", attachSeq},
            {"nvar_P_SVID_BOARD", code},
            {"nume_P_ATTACH_NO", 1 },
            {"nvar_P_ATTACH_P_NAME",fileName },
            {"nvar_P_ATTACH_I_NAME",iFileName },
            {"nvar_P_ATTACH_EXT", ext},
            {"nume_P_ATTACH_DOWNCNT",0 },
            {"nvar_P_ATTACH_SIZE", fileSize },
            {"nvar_P_ATTACH_PATH", filePath }
        };

        //실제 파일 업로드
        int maxSize = int.Parse(ConfigurationManager.AppSettings["" +
            "UploadFileMaxSize"]);
        FileHelper.FileUpload(FileUpload1, this.Page, fileName, maxSize, AdminId, "SystemUpdate", code); // 파일 업로드

        BoardService.SaveBoardAttach(paramList);       //파일 DB 저장
    }

    private void SendMMS()
    {

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_TYPE", "SYSTEM"},
        };
        UserService userService = new UserService();
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
                    {"nvar_P_SUBJECT", "[신규 시스템 개선 사항]"},
                    {"nvar_P_DEST_INFO", incomingUser.Substring(0, incomingUser.Length-1) },
                    {"nvar_P_MSG", "[신규 시스템 개선 사항]\r\n대상 : " + ddlComm.SelectedItem.Text.Trim() + "\r\n화면 : " + ddlView.SelectedItem.Text.Trim() + "\r\n제목 : " +  txtTitle.Text.Trim() + "\r\n요청자 : " + UserInfoObject.Name + "\r\n세부사항들 검토 및 대응 바랍니다."},
                };

                userService.MMSInsert(paramList2);
            }

        }
    }
    #endregion

    
}