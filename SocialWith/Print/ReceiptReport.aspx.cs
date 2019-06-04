using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.XtraReports.Web;
using Urian.Core;
using NLog;
using DevExpress.DataAccess.Sql;

public partial class Print_ReceiptReport : System.Web.UI.Page
{
    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        ReceiptReport report = new ReceiptReport();

        QueryParameter queryParam1 = ((DevExpress.DataAccess.Sql.SqlDataSource)report.DataSource).Queries[0].Parameters[0];
        QueryParameter queryParam2 = ((DevExpress.DataAccess.Sql.SqlDataSource)report.DataSource).Queries[0].Parameters[1];
        QueryParameter queryParam3 = ((DevExpress.DataAccess.Sql.SqlDataSource)report.DataSource).Queries[0].Parameters[2];

        queryParam1.Value = Request["OrderCodeNo"];
        queryParam2.Value = Request["SvidUser"];
        queryParam3.Value = Request["OrdStat"];

        ASPxWebDocumentViewer1.OpenReport(report);
    }
}