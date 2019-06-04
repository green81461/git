using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using Urian.Core;
using System.Data;
using System.Data.OleDb;
using System.Globalization;
using NLog;
using System.Configuration;
using SocialWith.Data.DistCSS;

/// <summary>
/// CommonHelper의 요약 설명입니다.
/// </summary>
public class CommonHelper
{
    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    public CommonHelper()
    {
        //
        // TODO: 여기에 생성자 논리를 추가합니다.
        //
    }

    // 로그인 처리 메서드(세션에 로그인 정보 저장)
    public static void SetLogIn(string svidUser, string strLoginID, string strMoveUrl, string gubun)
    {

        try
        {
            System.Web.Security.FormsAuthentication.RedirectFromLoginPage(strLoginID, false);

            string svidSessionKey = string.Empty;
            string loginIdsession = string.Empty;

            switch (gubun)
            {
                case "SU":
                    svidSessionKey = "AdminSub_Svid_User";
                    loginIdsession = "AdminSub_LoginID";
                    break;
                case "BU":
                    svidSessionKey = "Svid_User";
                    loginIdsession = "LoginID";
                    break;
                case "AU":
                    svidSessionKey = "Admin_Svid_User";
                    loginIdsession = "Admin_LoginID";
                    break;
                default:
                    svidSessionKey = "Svid_User";
                    loginIdsession = "LoginID";
                    break;
            }

            //string[] deleteKeys = { svidSessionKey , loginIdsession};
            //DeleteCookie(deleteKeys, HttpContext.Current.Request.Url.Host);

            HttpCookie sviduser = new HttpCookie(svidSessionKey, svidUser);
            HttpCookie id = new HttpCookie(loginIdsession, strLoginID);

            sviduser.Expires = DateTime.Now.AddHours(6);
            id.Expires = DateTime.Now.AddDays(6);

            HttpContext.Current.Response.SetCookie(sviduser);
            HttpContext.Current.Response.SetCookie(id);

            

            HttpContext.Current.Response.Redirect(strMoveUrl,false);
            
            //GetOrderDeliveryNoList(svidUser); // 배송완료 update
        }
        catch (Exception ex)
        {
            HttpContext.Current.Response.Write("<script>alert('로그인이 실패하였습니다. 계정을 다시 확인해주세요.');</script>");

            HttpContext.Current.Response.Redirect("../ErrorPage.aspx");
        }
    }

    public static void SetLogOut(string gubun) {


        System.Web.Security.FormsAuthentication.SignOut();

        string svidSessionKey = string.Empty;
        string loginIdsession = string.Empty;

        switch (gubun)
        {
            case "SU":
                svidSessionKey = "AdminSub_Svid_User";
                loginIdsession = "AdminSub_LoginID";
                break;
            case "BU":
                svidSessionKey = "Svid_User";
                loginIdsession = "LoginID";
                break;
            case "AU":
                svidSessionKey = "Admin_Svid_User";
                loginIdsession = "Admin_LoginID";
                break;
            default:
                svidSessionKey = "Svid_User";
                loginIdsession = "LoginID";
                break;
        }


        HttpCookie sviduser = new HttpCookie(svidSessionKey);
        HttpCookie id = new HttpCookie(loginIdsession);
        HttpCookie test = new HttpCookie("LoginId");


        sviduser.Expires = DateTime.Now.AddDays(-1d);
        id.Expires = DateTime.Now.AddDays(-1d);
        test.Expires = DateTime.Now.AddDays(-1d);

        HttpContext.Current.Response.SetCookie(sviduser);
        HttpContext.Current.Response.SetCookie(id);
        HttpContext.Current.Response.SetCookie(test);

        string redirectUrl = "/Member/Login.aspx";

        if (gubun == "AU") //로그아웃시 관리자일땐 관리자 로그인페이지로 리다이렉트
        {
            redirectUrl = "/Admin/Login.aspx";
        }
        HttpContext.Current.Response.Redirect(redirectUrl);
    }
    public static void SendMailService(string fromEmail, string toEmail, string subject, string bodyMessege) {

        MailMessage message = new MailMessage();
        message.From = new MailAddress(fromEmail); //ex : ooo@naver.com
        message.To.Add(toEmail); //ex : ooo@gmail.com
        message.Subject = subject;
        message.SubjectEncoding = Encoding.UTF8;
        message.Body = bodyMessege;

        message.BodyEncoding = Encoding.UTF8;
        message.SubjectEncoding = Encoding.UTF8;

        AlternateView htmlView = AlternateView.CreateAlternateViewFromString(bodyMessege);
        htmlView.ContentType = new System.Net.Mime.ContentType("text/html");
        message.AlternateViews.Add(htmlView);

        try
        {
            SmtpClient smtp = new SmtpClient("smtp.hiworks.com", 587);
            smtp.UseDefaultCredentials = false; // 시스템에 설정된 인증 정보를 사용하지 않는다.
            smtp.EnableSsl = true;  // SSL을 사용한다.
            smtp.DeliveryMethod = SmtpDeliveryMethod.Network; // 이걸 하지 않으면 인증을 받지 못한다.
            //smtp.Credentials = new NetworkCredential("service", "service2019@");
            smtp.Credentials = new NetworkCredential("service@socialwith.co.kr", "service2019@");
            smtp.Send(message);
        }
        catch (System.Exception e)
        {
            logger.Error(e, "SendMailService Error");
            throw;
        }
        
    }
    

    public static void DeleteCookie(string[] cookieKeys, string domain) {

        foreach (var key in cookieKeys)
        {
            HttpCookie oldCookie = new HttpCookie(key);
            oldCookie.Domain = domain;
            oldCookie.Expires = DateTime.Now.AddDays(-1d);
            HttpContext.Current.Response.SetCookie(oldCookie);
        }
        
    }
    
    public static string GetIP4Address()
    {
        string strIP4Address = String.Empty;

        foreach (IPAddress objIP in Dns.GetHostAddresses(Dns.GetHostName()))
        {
            if (objIP.AddressFamily.ToString() == "InterNetwork")
            {
                strIP4Address = objIP.ToString();
                break;
            }
        }
        return strIP4Address;
    }


    // 사용자 운송장번호로 배달완료인지 조회(기간: 오늘부터 7일전까지만)
    private static void GetOrderDeliveryNoList(string svidUser)
    {
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", svidUser}
        };

        SocialWith.Biz.Order.OrderService orderService = new SocialWith.Biz.Order.OrderService();

        var list = orderService.GetOrderDeliveryNoList(paramList);

        if ((list != null) && (list.Count > 0))
        {
            for (int i = 0; i < list.Count; i++)
            {
                GetDeliveryResult(svidUser, list[i].DeliveryNo);
            }
        }
    }
    // 배송완료인 주문상품들 배송완료로 상태코드 변경
    private static void GetDeliveryResult(string svidUser, string dlvrNo)
    {
        logger.Info("========================================= 배송완료 Update 시작 =====================================================");

        string strUri = "http://nplus.doortodoor.co.kr/web/info.jsp";

        StringBuilder dataParams = new StringBuilder();
        dataParams.Append("slipno=" + dlvrNo);

        byte[] byteDataParams = UTF8Encoding.UTF8.GetBytes(dataParams.ToString());

        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(strUri + "?" + dataParams);
            
        if (request != null)
        {

            request.Method = "GET";

            logger.Info("URL 정보 : " + strUri + "?" + dataParams);

            // Set some reasonable limits on resources used by this request
            request.AllowWriteStreamBuffering = false;
            request.Timeout = 3000;
            request.ReadWriteTimeout = 3000;
            //request.MaximumAutomaticRedirections = 4;
            //request.MaximumResponseHeadersLength = 4;
            // Set credentials to use for this request.
            request.Credentials = CredentialCache.DefaultCredentials;

            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            
            if (response != null)
            {
                Stream receiveStream = response.GetResponseStream();
                StreamReader readStream = new StreamReader(receiveStream, Encoding.Default);

                string strHtml = readStream.ReadToEnd();

                if (readStream != null)
                {
                    readStream.Close();
                    readStream.Dispose();
                }
                if (receiveStream != null)
                {
                    receiveStream.Close();
                    receiveStream.Dispose();
                }
                response.Close();

                //<td align=center>&nbsp;2017-11-28&nbsp;</td>
                Regex rgxHtml = new Regex("<td align=center>&nbsp;(?<text>.*?)&nbsp;</td>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
                //Match match = rgxHtml.Match(strHtml);

                int idx = 0;
                string[] textArr = new string[3];
                for (Match match = rgxHtml.Match(strHtml); match.Success; match = match.NextMatch())
                {
                    textArr[idx] = match.Groups["text"].Value;
                    logger.Info("text " + idx + " ====>  " + textArr[idx]);
                    ++idx;

                    if (idx > 2)
                    {
                        break;
                    }
                }

                if (textArr[2].AsText().Equals("배달완료"))
                {
                    SocialWith.Biz.Order.OrderService orderService = new SocialWith.Biz.Order.OrderService();
                    var deliveryDate = textArr[0].AsText() + " " + textArr[1].AsText();

                    var paramList = new Dictionary<string, object> {
                        {"nvar_P_SVID_USER", svidUser},
                        {"nvar_P_DELIVERYNO", dlvrNo},
                        {"nvar_P_DELIVERYDATE", deliveryDate}
                    };

                    orderService.UpdateOrderEnd(paramList); // 주문정보의 상태코드: 배송중(301) -> 배송완료(302) 변경

                    logger.Info("=== 택배 배송완료 값 저장함... ===> " + dlvrNo);
                }

                logger.Info("=========================== 택배 배송완료 값 정보 START =================================");
                logger.Info("SVID_USER = " + svidUser);
                logger.Info("DELIVERYNO = " + dlvrNo);
                logger.Info("DELIVERYDATE = " + (textArr[0].AsText() + " " + textArr[1].AsText()));
                logger.Info("=========================== 택배 배송완료 값 정보 END =================================");
            }
        }
            
        logger.Info("========================================= 배송완료 Update 끝 =====================================================");
        
    }

    public static DataTable ExcelToDataTable(string filePath, string sheetName)
    {
        DataTable dtexcel = new DataTable();
        bool hasHeaders = false;
        string HDR = hasHeaders ? "Yes" : "No";
        string strConn;

        if (filePath.Substring(filePath.LastIndexOf('.')).ToLower() == ".xlsx")
            strConn = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filePath + ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=1\";";
        else
            strConn = @"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filePath + ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=1\";";
        OleDbConnection conn = new OleDbConnection(strConn);
        conn.Open();
        DataTable schemaTable = conn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, new object[] { null, null, null, "TABLE" });

        string query = "SELECT  * FROM ["+ sheetName + "$]";
        OleDbDataAdapter daexcel = new OleDbDataAdapter(query, conn);
        dtexcel.Locale = CultureInfo.CurrentCulture;
        daexcel.Fill(dtexcel);
        conn.Close();
        return dtexcel;

    }

    public static OleDbDataReader ExcelToDatareader(string filePath, string sheetName)
    {
        DataTable dtexcel = new DataTable();
        bool hasHeaders = false;
        string HDR = hasHeaders ? "Yes" : "No";
        string strConn;

        if (filePath.Substring(filePath.LastIndexOf('.')).ToLower() == ".xlsx")
            strConn = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filePath + ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=1\";";
        else
            strConn = @"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filePath + ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=1\";";
        OleDbConnection conn = new OleDbConnection(strConn);
        conn.Open();
        var sourceCommand = new OleDbCommand("SELECT  * FROM [" + sheetName + "$]", conn);
        var reader = sourceCommand.ExecuteReader();
        conn.Close();
        return reader;

    }


    //로컬아이피여부 체크
    public static bool IsLocalIpAddress(string host)
    {
        try
        { // get host IP addresses
            IPAddress[] hostIPs = Dns.GetHostAddresses(host);
            // get local IP addresses
            IPAddress[] localIPs = Dns.GetHostAddresses(Dns.GetHostName());

            // test if any host IP equals to any local IP or to localhost
            foreach (IPAddress hostIP in hostIPs)
            {
                // is localhost
                if (IPAddress.IsLoopback(hostIP)) return true;
                // is local address
                foreach (IPAddress localIP in localIPs)
                {
                    if (hostIP.Equals(localIP)) return true;
                }
            }
        }
        catch { }
        return false;
    }


    //도메인명 추출
    public static string SiteName()
    {
        string url = HttpContext.Current.Request.Url.Host;
        if (url.Trim().StartsWith("www"))
        {
            url = url.Trim().Split('.')[1];
        }
        else
        {
            url = url.Trim().Split('.')[0];
        }
        return url;
    }


    //마스터페이지 경로 갖고오기
    public static string GetMasterPageUrl(DistCssInfo distCssInfo ) {

        string siteType = ConfigurationManager.AppSettings["SiteType"].AsText();
        string settingDistCssCode = ConfigurationManager.AppSettings["SettingDistCssCode"].AsText();//개발자용 배포코드
        string distCode = "DS00000002"; //기본 사이트배포코드값

        if (siteType == "Localhost")//Webconfig의 SiteType가 Localhost(개발자용)이면 Webconfig의 SettingDistCssCode의값을 갖고온다
        {
            distCode = settingDistCssCode;
        }
        else if (distCssInfo != null) //Webconfig의 SiteType가 Localhost(개발자용)가 아니고 DistCssObject가 널이 아니면 DistCssObject의 코드값을 갖고온다
        {
            distCode = distCssInfo.DistCssCode.AsText("DS00000002"); //사이트배포 데이터가 있으면 해당 코드를 갖고온다

        }
        string masterPageUrl = "~/UploadFile/SiteManagement/" + distCode + "/Main/Default.master"; //마스터페이지 분기처리(해당코드경로의 마스터페이지를 갖고옴)
        return masterPageUrl;
    }
}