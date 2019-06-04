using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using SocialWith.Data.Comm;

public partial class Board_BoardList : PageBase
{
    protected int CurrentPage;
    protected SocialWith.Biz.Comm.CommService commService = new SocialWith.Biz.Comm.CommService();
    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;
    }
    protected void Page_Load(object sender, EventArgs e)
    {
      
        
        if (IsPostBack == false)
        {
            
        }
    }

    // 문의구분 목록 조회
    //protected List<CommDTO> GetCommList(string mapCode, int mapChanel)
    //{
    //    var paramList = new Dictionary<string, object>
    //    {
    //        {"nvar_P_MAPCODE", mapCode },
    //        {"inte_P_MAPCHANEL", mapChanel }
    //    };

    //    var list = commService.GetCommList(paramList);

    //    return list;
    //}


   
   
    
}