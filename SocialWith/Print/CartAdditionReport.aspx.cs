﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.XtraReports.Web;
using Urian.Core;
using NLog;
using DevExpress.DataAccess.Sql;

public partial class Print_CartAdditionReport : System.Web.UI.Page
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
        CartAdditionReport report = new CartAdditionReport();

        QueryParameter queryParam1 = ((DevExpress.DataAccess.Sql.SqlDataSource)report.DataSource).Queries[0].Parameters[0];
        QueryParameter queryParam2 = ((DevExpress.DataAccess.Sql.SqlDataSource)report.DataSource).Queries[0].Parameters[1];
        QueryParameter queryParam3 = ((DevExpress.DataAccess.Sql.SqlDataSource)report.DataSource).Queries[0].Parameters[2];
        QueryParameter queryParam4 = ((DevExpress.DataAccess.Sql.SqlDataSource)report.DataSource).Queries[0].Parameters[3];
        QueryParameter queryParam5 = ((DevExpress.DataAccess.Sql.SqlDataSource)report.DataSource).Queries[0].Parameters[4];
        QueryParameter queryParam6 = ((DevExpress.DataAccess.Sql.SqlDataSource)report.DataSource).Queries[0].Parameters[5];
        queryParam1.Value = Request["SvidUser"];
        queryParam2.Value = Request["CartNos"];
        queryParam3.Value = Request["CompCode"];
        queryParam4.Value = Request["Dcheck"].AsText("N");
        queryParam5.Value = Request["FreeCompFlag"].AsText("N");
        queryParam6.Value = Request["Percent"];
        
        ASPxWebDocumentViewer1.OpenReport(report);
    }
}