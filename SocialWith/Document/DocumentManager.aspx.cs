using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Document;
using Urian.Core;

public partial class Document_DocumentManager : PageBase
{
    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack == false)
        {
            DocumnetBind();
        }
    }

    protected void DocumnetBind(int page = 1)
    {
        DocumentService documentService = new DocumentService();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHKEYWORD", txtSearch.Text.Trim() },
            {"nvar_P_SEARCHTARGET",ddlSearchTarget.SelectedValue },
            {"nvar_P_SVID_USER",Svid_User },
            {"inte_P_PAGENO", page },
            {"inte_P_PAGESIZE", 20 },
        };

        var list = documentService.GetDocumentList(paramList);

        int listCount = 0;

        if (list != null)
        {
            if (list.Count > 0)
            {
                listCount = list.FirstOrDefault().TotalCount;
            }

        }

        ucListPager.TotalRecordCount = listCount;
        lvDocumentList.DataSource = list;
        lvDocumentList.DataBind();

    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DocumnetBind();
    }

    protected void ucListPager_PageIndexChange(object sender)
    {
        DocumnetBind(ucListPager.CurrentPageIndex);
    }


    protected void lvDocumentList_ItemCommand(object sender, ListViewCommandEventArgs e)
    {
        if (e.CommandName == "Download")
        {
            var path = e.CommandArgument.AsText();
            var hfFileName = (HiddenField)e.Item.FindControl("hfFileName");
            string uploadFolderServerPath = Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
            string fileFullPath = string.Empty;
            if (!String.IsNullOrEmpty(path) && hfFileName != null)
            {

                fileFullPath = uploadFolderServerPath + path + hfFileName.Value;
                FileHelper.FileDownload(this.Page, fileFullPath, hfFileName.Value);
            }

        }
    }
}