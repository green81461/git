using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class UserControl_ucListControl : System.Web.UI.UserControl
{
    #region Control Property 설정

    // 전체 항목 수
    public int TotalRecordCount
    {
        get
        {
            int returnValue = 0;
            try
            {
                if (this.ViewState["TotalRecordCount"] != null)
                { returnValue = Convert.ToInt32(this.ViewState["TotalRecordCount"]); }
            }
            catch
            { returnValue = 0; }

            return returnValue;
        }
        set
        { this.ViewState["TotalRecordCount"] = value.ToString(); }
    }

    // 페이지 사이즈
    public int PageSize
    {
        get
        {
            int returnValue = 10;
            try
            {
                if (this.ViewState["PageSize"] != null)
                { returnValue = Convert.ToInt32(this.ViewState["PageSize"]); }
            }
            catch
            { returnValue = 10; }

            return returnValue;
        }
        set
        { this.ViewState["PageSize"] = value.ToString(); }
    }

    // 전체 페이지 수
    public int TotalPageCount
    {
        get
        {
            int totalPageCount = this.TotalRecordCount / this.PageSize + ((this.TotalRecordCount % this.PageSize) == 0 ? 0 : 1);
            return totalPageCount;
        }
    }

    // 현재 페이지
    public int CurrentPageIndex
    {
        get
        {
            int currentPageIndex = 1;
            try
            {
                if (this.ViewState["CurrentPageIndex"] != null)
                { currentPageIndex = Convert.ToInt32(this.ViewState["CurrentPageIndex"]); }
            }
            catch
            { currentPageIndex = 1; }

            if (currentPageIndex < 1)
            {
                currentPageIndex = 1;
                this.ViewState["CurrentPageIndex"] = currentPageIndex.ToString();
            }
            return currentPageIndex;
        }
        set
        {
            this.ViewState["CurrentPageIndex"] = value.ToString();
        }
    }

    // 현재 페이지의 시작 아이템 넘버
    public int CurrentStartIndex
    {
        get
        {
            return (this.CurrentPageIndex - 1) * this.PageSize;
        }
    }

    // 페이지 인덱스의 최대 수
    public int MaxPageDisplaySize
    {
        get
        {
            int returnValue = 10;
            try
            {
                if (this.ViewState["MaxPageDisplaySize"] != null)
                { returnValue = Convert.ToInt32(this.ViewState["MaxPageDisplaySize"]); }
            }
            catch
            { returnValue = 10; }

            return returnValue;
        }
        set
        {
            this.ViewState["MaxPageDisplaySize"] = value.ToString();
        }
    }

    #endregion


    #region Control Override 설정

    protected override void OnPreRender(EventArgs e)
    {
        base.OnPreRender(e);
        this.GeneratePageList();
    }

    #endregion



    protected void Page_Load(object sender, EventArgs e)
    {

    }


    #region 사용자 정의 메서드

    private void GeneratePageList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("&nbsp; &nbsp;");

        try
        {
            int totalPageCount = this.TotalPageCount;
            int currentPageIndex = this.CurrentPageIndex;
            int maxPageList = this.MaxPageDisplaySize;

            if (0 == totalPageCount)
            {
                this.divPanel.Visible = false;
                return;
            }
            else
            {
                this.divPanel.Visible = true;
            }

            int startPageIndex = 0;
            if (0 == currentPageIndex % maxPageList)
            {
                startPageIndex = (currentPageIndex / maxPageList) * (maxPageList) - maxPageList + 1;
            }
            else
            {
                startPageIndex = (currentPageIndex / maxPageList) * maxPageList + 1;
            }

            int endPageIndex = 0;
            if (totalPageCount + 1 > (startPageIndex + maxPageList))
            {
                endPageIndex = startPageIndex + maxPageList;
            }
            else
            {
                endPageIndex = startPageIndex + (totalPageCount % maxPageList == 0 ? maxPageList : totalPageCount % maxPageList);
            }

            for (int i = startPageIndex; i < endPageIndex; i++)
            {
                if (i == CurrentPageIndex)
                {
                    sb.Append("<li class='paginationjs-page J-paginationjs-page active'><a>" + i.ToString() + "</a></li>");
                }
                else
                {
                    sb.Append("<li class='paginationjs-page J-paginationjs-page'><a href=\"javascript:goSelectedPage('" + i.ToString() + "')\" style='color: #a2a2a2;'>" + i.ToString() + "</a></li>");
                }

                sb.Append("&nbsp; &nbsp;");
            }

            lblPageList.Text = sb.ToString();
        }
        catch
        {
        }
    }

    public delegate void PagerClickEventHandler(object sender);
    public event PagerClickEventHandler PageIndexChange;
    private void CallPageIndexChangeEvent()
    {
        this.PageIndexChange(this);
    }

    //protected void btnGoFirstPage_Click(object sender, EventArgs e)
    //{
    //    this.CurrentPageIndex = 1;
    //    CallPageIndexChangeEvent();
    //}

    //protected void btnGoPreviousPage_Click(object sender, EventArgs e)
    //{
    //    if (2 <= this.CurrentPageIndex)
    //    {
    //        this.CurrentPageIndex = this.CurrentPageIndex - 1;
    //        CallPageIndexChangeEvent();
    //    }
    //}

    //protected void btnGoNextPage_Click(object sender, EventArgs e)
    //{
    //    if (this.TotalPageCount > this.CurrentPageIndex)
    //    {
    //        this.CurrentPageIndex = this.CurrentPageIndex + 1;
    //        CallPageIndexChangeEvent();
    //    }
    //}

    //protected void btnGoLastPage_Click(object sender, EventArgs e)
    //{
    //    this.CurrentPageIndex = this.TotalPageCount;
    //    CallPageIndexChangeEvent();
    //}

    protected void btnGoSelectedPage_Click(object sender, EventArgs e)
    {
        try
        {
            int newPageIndex = Convert.ToInt32(hfCurrentPageIndex.Value);
            this.CurrentPageIndex = newPageIndex;
            this.CallPageIndexChangeEvent();
        }
        catch
        { }
    }

    #endregion

    protected void btnGoFirstPage_Click(object sender, ImageClickEventArgs e)
    {
        this.CurrentPageIndex = 1;
        CallPageIndexChangeEvent();
    }

    protected void btnGoPreviousPage_Click(object sender, ImageClickEventArgs e)
    {
        if (2 <= this.CurrentPageIndex)
        {
            this.CurrentPageIndex = this.CurrentPageIndex - 1;
            CallPageIndexChangeEvent();
        }
    }

    protected void btnGoNextPage_Click(object sender, ImageClickEventArgs e)
    {
        if (this.TotalPageCount > this.CurrentPageIndex)
        {
            this.CurrentPageIndex = this.CurrentPageIndex + 1;
            CallPageIndexChangeEvent();
        }
    }

    protected void btnGoLastPage_Click(object sender, ImageClickEventArgs e)
    {
        this.CurrentPageIndex = this.TotalPageCount;
        CallPageIndexChangeEvent();
    }
}