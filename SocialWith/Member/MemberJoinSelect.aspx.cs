using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Member_MemberJoinSelect : LoginPageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btnJoin1_Click(object sender, EventArgs e)
    {
        joinType.Text = "1";
        //Server.Transfer("이동할폴더.aspx?joinType=" + joinType);
        //this.txtCheck.Text = Request["joinType"];     <--받을 곳에서 선언할 것.
        //Response.Redirect("MemberCreate_A.aspx?joinType=" + joinType);
        Response.Redirect("Agreement.aspx?joinType=B");
    }


    protected void btnJoin2_Click(object sender, EventArgs e)
    {
        joinType.Text = "2";
        //Server.Transfer("이동할폴더.aspx?joinType=" + joinType);
        //this.txtCheck.Text = Request["joinType"];     <--받을 곳에서 선언할 것.
        //Response.Redirect("MemberCreate_B.aspx?joinType=" + joinType);
        Response.Redirect("Agreement.aspx?joinType=A");
    }
}