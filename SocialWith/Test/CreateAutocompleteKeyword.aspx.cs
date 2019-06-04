using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Goods;

public partial class Test_CreateAutocompleteKeyword : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void btnCreateRemindSearch_Click(object sender, EventArgs e)
    {
        GoodsService goodsService = new GoodsService();
        var param = new Dictionary<string, object> { };
        var list = goodsService.GoodsAutoCompleteList(param).Select(P=>P.GoodsRemindSearch);
        var addlist = new List<string>();

        foreach (var item in list)
        {
            var texts = item.Split(',');
            foreach (var text in texts)
            {
                if (!addlist.Contains(text))
                {
                    addlist.Add(text);
                }
            }
        }

        string jsondata = new JavaScriptSerializer().Serialize(addlist);
        File.WriteAllText(@"D:\SocialWith\UploadFile\AutoComplete\SampleLog.json", jsondata);
    }
}