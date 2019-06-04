<%@ Application Language="C#" %>
<%@ Import Namespace="SocialWith" %>
<%@ Import Namespace="System.Web.Optimization" %>
<%@ Import Namespace="System.Web.Routing" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="Urian.Core" %>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="NLog" %>

<script runat="server">

    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    void Application_Start(object sender, EventArgs e)
    {

        RouteConfig.RegisterRoutes(RouteTable.Routes);
        BundleConfig.RegisterBundles(BundleTable.Bundles);

    }

    void Application_BeginRequest(Object sender, EventArgs e)
    {
    }

    protected void Application_Error(object sender, EventArgs e)
    {
        Exception ex = HttpContext.Current.Server.GetLastError();
        string err = "\r\n 에러 발생 원인 : " + ex.Source +
                     "\r\n 에러 메시지    : " + ex.Message +
                     "\r\n Stack Trace    : " + ex.StackTrace.ToString() +
                     "\r\n 내부 오류      : " + ex.InnerException;

        logger.Error("Error Url={0},  Message={1}", Request.Url.Host, err);

        string uri = HttpContext.Current.Request.Url.AbsoluteUri;
        HttpContext.Current.ClearError();

        if (uri.IndexOf("/Admin/") > -1)
        {
            Response.Redirect("/Admin/ErrorPage.aspx", false);
        }
        else if (uri.IndexOf("/AdminSub/") > -1)
        {
            Response.Redirect("/AdminSub/ErrorPage.aspx", false);
        }
        else
        {
            Response.Redirect("/ErrorPage.aspx", false);
        }
    }
</script>
