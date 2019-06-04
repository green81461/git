using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Member_GetCommData : System.Web.UI.Page
{
    protected SocialWith.Biz.Comm.CommService CommService = new SocialWith.Biz.Comm.CommService();
    protected void Page_Load(object sender, EventArgs e)
    {
        GetCommList();
    }

    protected void GetCommList()
    {

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPCODE", "MEMBER"},
            { "nume_P_MAPCHANEL", 1},
        };

        var list = CommService.GetCommList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
        
    }
    
}