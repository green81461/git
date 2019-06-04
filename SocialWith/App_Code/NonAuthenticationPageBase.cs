using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using NLog;

/// <summary>
/// NonAuthenticationPageBase의 요약 설명입니다.
/// </summary>
public class NonAuthenticationPageBase : System.Web.UI.Page
{
    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    public NonAuthenticationPageBase()
    {
        //
        // TODO: 여기에 생성자 논리를 추가합니다.
        //
    }
}