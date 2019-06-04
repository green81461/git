<%@ WebHandler Language="C#" Class="DistCssHandler" %>

using System;
using System.Web;
using SocialWith.Biz.Brand;
using System.Collections.Generic;
using Newtonsoft.Json;
using Urian.Core;
using SocialWith.Biz.DistCss;
using System.Configuration;
using System.Linq;
using System.IO;
using NLog;
using System.Web.Script.Serialization;
using Oracle.ManagedDataAccess.Client;
public class DistCssHandler : IHttpHandler {
    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion
    protected DistCssService DistCssService = new DistCssService();
    public void ProcessRequest (HttpContext context) {

        string method = context.Request.Form["Method"];
        switch (method)
        {
            case "GetNextCode":
                GetNextCode(context);
                break;
            case "GetDistList":
                GetDistList(context);
                break;
            case "GetDistCopyList":
                GetDistCopyList(context);
                break;
            case "GetDefaultInfo":
                GetDefaultInfo(context);
                break;
            case "GetDistInfo":
                GetDistInfo(context);
                break;
            case "GetDistCssMenu":
                GetDistCssMenu(context);
                break;
            case "GetDistCssRoll":
                GetDistCssRoll(context);
                break;
            case "GetDistCssMasterRollMaster":
                GetDistCssMasterRollMaster(context);
                break;
            case "GetDistCssMasterRollDetail":
                GetDistCssMasterRollDetail(context);
                break;
            case "GetDistCssCategoryLandingList":
                GetDistCssCategoryLandingList(context);
                break;
            case "GetDistCssPartner":
                GetDistCssPartner(context);
                break;
            case "GetDistCssDiperson":
                GetDistCssDiperson(context);
                break;
            case "GetDistCssPopup":
                GetDistCssPopup(context);
                break;
            case "SaveDistDefault":
                SaveDistDefault(context);
                break;
            case "SaveDist":
                SaveDist(context);
                break;
            case "CopyDist":
                CopyDist(context);
                break;
            case "SaveDistMenu":
                SaveDistMenu(context);
                break;

            case "SaveDistRoll":
                SaveDistRoll(context);
                break;
            case "SaveDistBanner":
                SaveDistBanner(context);
                break;
            case "SaveDistBannerDetail":
                SaveDistBannerDetail(context);
                break;
            case "SaveDistPartner":
                SaveDistPartner(context);
                break;
            case "SaveDistPartner_Type2":
                SaveDistPartner_Type2(context);
                break;
            case "SaveDistPopup":
                SaveDistPopup(context);
                break;
            case "SaveDistPopupAll":
                SaveDistPopupAll(context);
                break;
            case "DeleteDistRoll":
                DeleteDistRoll(context);
                break;
            case "DeleteDistBanner":
                DeleteDistBanner(context);
                break;
            case "DeleteDistPartner":
                DeleteDistPartner(context);
                break;
            case "DeleteDistDiperson":
                DeleteDistDiperson(context);
                break;
            case "DeleteDistPopup":
                DeleteDistPopup(context);
                break;
            case "DeleteDistAll":
                DeleteDistAll(context);
                break;
            case "GetSubMenuList":
                GetSubMenuList(context);
                break;
            case "DeleteDistMgtImg":
                DeleteDistMgtImg(context);
                break;
            case "DeleteMenuImg":
                DeleteMenuImg(context);
                break;
            case "DeleteBannerImg":
                DeleteBannerImg(context);
                break;
            case "DeleteDistBannerImg":
                DeleteDistBannerImg(context);
                break;
            case "DeletePartnerImg":
                DeletePartnerImg(context);
                break;
            case "DeleteDipersonImg":
                DeleteDipersonImg(context);
                break;
            case "DeletePopupImg":
                DeletePopupImg(context);
                break;
            case "GetDistCssPkg":
                GetDistCssPkg(context);
                break;
            case "GetDistCssAdminSubPkg":
                GetDistCssAdminSubPkg(context);
                break;
            //case "GetNextDistCssMasterRollSeq":
            //    GetNextDistCssMasterRollSeq(context);
            //    break;
            //case "GetNextDistCssCategoryLandingSeq":
            //    GetNextDistCssCategoryLandingSeq(context);
            //    break;
            //case "GetNextDistCssPartnerSeq":
            //    GetNextDistCssPartnerSeq(context);
            //    break;
            //case "GetNextDistCssDipersonSeq":
            //    GetNextDistCssDipersonSeq(context);
            //    break;

            default:
                break;
        }

    }


    protected void GetNextCode(HttpContext context)
    {
        var lastCode = DistCssService.GetLastDistCssCode();
        string nextCode = StringValue.NextDistCssCode(lastCode); //코드 자동생성

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write(nextCode);
    }

    protected void GetDistList(HttpContext context)
    {
        string gubun = context.Request.Form["Gubun"].AsText();
        string gubunInfo = context.Request.Form["GubunInfo"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_GUBUN", gubun},
            { "nvar_P_GUBUNINFO", gubunInfo},
            { "nvar_P_COMPCODE", compCode},
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize},

        };

        var list = DistCssService.GetDistCssList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetDistCopyList(HttpContext context)
    {
        string baseCode = context.Request.Form["BaseCode"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string gubunInfo = context.Request.Form["GubunInfo"].AsText();
        string keyword = context.Request.Form["Keyword"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_BASEDISTCSSCODE", baseCode},
            { "nvar_P_GUBUN", gubun},
            { "nvar_P_GUBUNINFO", gubunInfo},
            { "nvar_P_SEARCHKEYWORD", keyword},
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize},

        };

        var list = DistCssService.GetDistCssCopyList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetDefaultInfo(HttpContext context)
    {
        string gubun = context.Request.Form["Gubun"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_GUBUN", gubun},
            { "nvar_P_COMPCODE", compCode},
        };

        var list = DistCssService.GetDefaultDistCss(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetDistInfo(HttpContext context)
    {
        string dCode = context.Request.Form["DCode"].AsText();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", dCode},
        };

        var list = DistCssService.GetDistCssInfo(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }



    protected void GetDistCssMenu(HttpContext context)
    {
        string code = context.Request.Form["Code"].AsText();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", code},
        };

        var list = DistCssService.GetDistCssMenuList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetDistCssRoll(HttpContext context)
    {
        string code = context.Request.Form["Code"].AsText();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", code},
        };

        var list = DistCssService.GetDistCssRollList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }


    protected void GetDistCssMasterRollMaster(HttpContext context)
    {
        string code = context.Request.Form["Code"].AsText();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", code},
        };

        var list = DistCssService.GetDistCssRollMasterList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetDistCssMasterRollDetail(HttpContext context)
    {
        string code = context.Request.Form["Code"].AsText();
        int mseq = context.Request.Form["Mseq"].AsInt();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", code},
            { "nume_P_MASTERSEQ", mseq},
        };

        var list = DistCssService.GetDistCssRollDetailList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetDistCssCategoryLandingList(HttpContext context)
    {
        string code = context.Request.Form["Code"].AsText();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", code},
        };

        var list = DistCssService.GetDistCssCategoryLandingList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetDistCssPkg(HttpContext context)
    {
        string code = context.Request.Form["Code"].AsText();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", code},
        };

        var list = DistCssService.GetDistCssPackage(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetDistCssAdminSubPkg(HttpContext context)
    {
        string code = context.Request.Form["Code"].AsText();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", code},
        };

        var list = DistCssService.GetDistCssAdminSubPackage(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetDistCssPartner(HttpContext context)
    {
        string code = context.Request.Form["Code"].AsText();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", code},
        };

        var list = DistCssService.GetDistCssPartnerList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetDistCssDiperson(HttpContext context)
    {
        string code = context.Request.Form["Code"].AsText();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", code},
        };

        var list = DistCssService.GetDistCssDipersonList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetDistCssPopup(HttpContext context)
    {
        string code = context.Request.Form["Code"].AsText();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", code},
        };

        var list = DistCssService.GetDistCssPopupList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }


    protected void SaveDistDefault(HttpContext context)
    {
        string gubun = context.Request.Form["Gubun"].AsText();
        string dCode = context.Request.Form["DCode"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();



        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_GUBUN", gubun },
            { "nvar_P_COMPCODE", compCode },
            { "nvar_P_DISTCODE", dCode },
            { "reVa_P_RETURN", ""},

        };

        string defaultDistCode = DistCssService.SaveDefaultDist(paramList);

        string defaultDerectory =  "\\SiteManagement\\" + defaultDistCode;
        var uploadFolder = context.Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]);
        var newDirectory = "\\SiteManagement\\" + dCode;
        FileHelper.CopyFolder(uploadFolder+defaultDerectory,uploadFolder+newDirectory);
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }



    protected void SaveDist(HttpContext context)
    {
        string dCode = context.Request.Form["DCode"].AsText();
        string dName = context.Request.Form["DName"].AsText();
        string url = context.Request.Form["Url"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string compName = context.Request.Form["CompName"].AsText();
        string distCompName = context.Request.Form["DistCompName"].AsText();
        string defaultYN = context.Request.Form["DefaultYN"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string gubunInfo = context.Request.Form["GubunInfo"].AsText();
        string pgconfirmYN = context.Request.Form["PgconfirmYN"].AsText();
        string metaTag = context.Request.Form["MetaTag"].AsText();
        string browerTag = context.Request.Form["BrowerTag"].AsText();
        string searchTag = context.Request.Form["SearchTag"].AsText();
        string sslYN = context.Request.Form["SslYN"].AsText();
        string googleCode = context.Request.Form["GoogleCode"].AsText();
        string custTelNo = context.Request.Form["CustTelNo"].AsText();
        string delflag = context.Request.Form["Delflag"].AsText();
        string emtcName = context.Request.Form["EmtcName"].AsText();
        string emtcPath = context.Request.Form["EmtcPath"].AsText();
        string cssName = context.Request.Form["CssName"].AsText();
        string cssPath = context.Request.Form["CssPath"].AsText();
        string tImageName = context.Request.Form["TImageName"].AsText();
        string tImagePath = context.Request.Form["TImagePath"].AsText();
        string bImageName = context.Request.Form["BImageName"].AsText();
        string bImagePath = context.Request.Form["BImagePath"].AsText();
        string copyRName = context.Request.Form["CopyRName"].AsText();
        string copyRPath = context.Request.Form["CopyRPath"].AsText();
        string companyDirection = context.Request.Form["CompanyDirection"].AsText();
        string companyDirectionCaption = context.Request.Form["CompanyDirectionCaption"].AsText();
        string tbannerCaption = context.Request.Form["TopBannerCaption"].AsText();
        string tbannerPath = context.Request.Form["TopBannerPath"].AsText();
        string tbannerDCaption = context.Request.Form["TopBannerDetailCaption"].AsText();
        string tbannerDPath = context.Request.Form["TopBannerDetailPath"].AsText();
        string tbannerUrl = context.Request.Form["TopBannerUrl"].AsText();
        string tbannerDelflag = context.Request.Form["TopBannerDelflag"].AsText();
        string loginEname = context.Request.Form["LoginBrowseEmtcName"].AsText();
        string loginEPath = context.Request.Form["LoginBrowseEmtcPath"].AsText();
        string loginEDelflag = context.Request.Form["LoginBrowseEmtcDelflag"].AsText();
        string loginTbannerCaption = context.Request.Form["LoginTopBannerCaption"].AsText();
        string loginTbannerPath = context.Request.Form["LoginTopBannerPath"].AsText();
        string loginTbannerDelflag = context.Request.Form["LoginTopBannerDelflag"].AsText();
        string loginBgName = context.Request.Form["LoginBgImgName"].AsText();
        string loginBgPath = context.Request.Form["LoginBgImgPath"].AsText();
        string loginDelflag = context.Request.Form["LoginBgImgDelflag"].AsText();
        string loginCompLogoName = context.Request.Form["LoginCompLogoName"].AsText();
        string loginCompLogoPath = context.Request.Form["LoginCompLogoPath"].AsText();
        string loginCompLogoDelflag = context.Request.Form["LoginCompLogoDelflag"].AsText();
        string loginCopyrightName = context.Request.Form["LoginCopyrightName"].AsText();
        string loginCopyrightPath = context.Request.Form["LoginCopyrightPath"].AsText();
        string loginCopyrightDelflag = context.Request.Form["LoginCopyrightDelflag"].AsText();






        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", dCode },
            { "nvar_P_DISTCSSNAME", dName },
            { "nvar_P_ENTERURL", url },
            { "nvar_P_COMPANYCODE", compCode },
            { "nvar_P_COMPANYNAME", compName },
            { "nvar_P_DISTCOMPANYNAME", distCompName },
            { "nvar_P_DEFALUTCSSYN", defaultYN },
            { "nvar_P_GUBUN", gubun },
            { "nvar_P_GUBUNINFO", gubunInfo },
            { "nvar_P_PGCONFIRMYN", pgconfirmYN },
            { "nvar_P_METATAG", metaTag },
            { "nvar_P_BROWSERTAG", browerTag },
            { "nvar_P_SEARCHTAG", searchTag },
            { "nvar_P_DISTSSLCONFIRMYN", sslYN },
            { "nvar_P_DISTGOOLECODE", googleCode },
            { "nvar_P_DISTCUSTTELNO", custTelNo },
            { "nvar_P_DELFLAG", delflag },
            { "nvar_P_BROWSEEMTCNAME", emtcName },
            { "nvar_P_BROWSEEMTCPATH", emtcPath },
            { "nvar_P_CSSNAME", cssName },
            { "nvar_P_CSSPATH", cssPath },
            { "nvar_P_TOPLOGOIMAGENAME", tImageName },
            { "nvar_P_TOPLOGOIMAGEPATH", tImagePath },
            { "nvar_P_BOTTOMLOGOIMAGENAME", bImageName },
            { "nvar_P_BOTTOMLOGOIMAGEPATH", bImagePath },
            { "nvar_P_COPYRNAME", copyRName },
            { "nvar_P_COPYRPATH", copyRPath },
            { "nvar_P_COMPANYDIRECTION", companyDirection },
            { "nvar_P_COMPANYDIRECTIONCAPTION", companyDirectionCaption },
            { "nvar_P_TOPBANNERCAPTION", tbannerCaption },
            { "nvar_P_TOPBANNERPATH", tbannerPath },
            { "nvar_P_TOPBANNERDETAILCAPTION", tbannerDCaption },
            { "nvar_P_TOPBANNERDETAILPATH", tbannerDPath },
            { "nvar_P_TOPBANNERURL", tbannerUrl },
            { "nvar_P_TOPBANNERDELFLAG", tbannerDelflag },
            { "nvar_P_LOGINBROWSEEMTCNAME", loginEname },
            { "nvar_P_LOGINBROWSEEMTCPATH", loginEPath },
            { "nvar_P_LOGINBROWSEEMTCDELFLAG", loginEDelflag },
            { "nvar_P_LOGINTOPBANNERCAPTION", loginTbannerCaption },
            { "nvar_P_LOGINTOPBANNERPATH", loginTbannerPath },
            { "nvar_P_LOGINTOPBANNERDELFLAG", loginTbannerDelflag },
            { "nvar_P_LOGINBACKGROUNDIMAGENAME", loginBgName },
            { "nvar_P_LOGINBACKGROUNDIMAGEPATH", loginBgPath },
            { "nvar_P_LOGINBACKGROUNDIMAGEDELFLAG", loginDelflag },
            { "nvar_P_LOGINCOMPANYLOGONAME", loginCompLogoName },
            { "nvar_P_LOGINCOMPANYLOGOPATH", loginCompLogoPath },
            { "nvar_P_LOGINCOMPANYLOGODELFLAG", loginCompLogoDelflag },
            { "nvar_P_LOGINCOPYLIGHTNAME", loginCopyrightName },
            { "nvar_P_LOGINCOPYLIGHTPATH", loginCopyrightPath },
            { "nvar_P_LOGINCOPYLIGHTDELFLAG", loginCopyrightDelflag },
        };


        DistCssService.SaveDistMgt(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }



    protected void CopyDist(HttpContext context)
    {
        string baseDCode = context.Request.Form["BaseDCode"].AsText();
        string destDCodes = context.Request.Form["DestDCodes"].AsText();
        string destTypes = context.Request.Form["DestTypes"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", baseDCode },
            { "nvar_P_DESTDISTCSSCODES", destDCodes},
            { "nvar_P_DESTTYPES", destTypes},

        };

        DistCssService.DistMgtCopy(paramList);
        var uploadFolder = context.Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]);


        foreach (string destDcode in destDCodes.Split('/'))
        {
            foreach (string folrderType in destTypes.Split('/'))
            {
                string defaultDerectory = "\\SiteManagement\\" + baseDCode+"\\" + folrderType;
                FileHelper.CopyFolder(uploadFolder+defaultDerectory, uploadFolder+"\\SiteManagement\\"+destDcode+"\\" + folrderType);
            }

        }

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }



    protected void SaveDistMenu(HttpContext context)
    {
        string dCode = context.Request.Form["DCode"].AsText();
        string dName = context.Request.Form["DName"].AsText();
        string url = context.Request.Form["Url"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string gubunInfo = context.Request.Form["GubunInfo"].AsText();
        string pgconfirmYN = context.Request.Form["PgconfirmYN"].AsText();
        string sslYN = context.Request.Form["SslYN"].AsText();
        string menuData = context.Request.Form["MenuData"].AsText();
        var obj = JsonConvert.DeserializeObject<List<Dictionary<string, string>>>(menuData);

        using (OracleConnection connection = new OracleConnection(ConfigurationManager.AppSettings["ConnectionString"]))
        {
            connection.Open();
            using (OracleTransaction trans = connection.BeginTransaction())
            {

                try
                {
                    var paramList1 = new Dictionary<string, object>
                    {
                        { "nvar_P_DISTCSSCODE", dCode },
                        { "nvar_P_DISTCSSNAME", dName },
                        { "nvar_P_ENTERURL", url },
                        { "nvar_P_COMPANYCODE", "" },
                        { "nvar_P_COMPANYNAME", "" },
                        { "nvar_P_DISTCOMPANYNAME", "" },
                        { "nvar_P_DEFALUTCSSYN", "N" },
                        { "nvar_P_GUBUN", gubun },
                        { "nvar_P_GUBUNINFO", gubunInfo },
                        { "nvar_P_PGCONFIRMYN", pgconfirmYN },
                        { "nvar_P_METATAG", "" },
                        { "nvar_P_BROWSERTAG", "" },
                        { "nvar_P_SEARCHTAG", "" },
                        { "nvar_P_DISTSSLCONFIRMYN", sslYN },
                        { "nvar_P_DISTGOOLECODE", "" },
                        { "nvar_P_DISTCUSTTELNO", "" },
                        { "nvar_P_DELFLAG", "N" },

                    };

                    DistCssService.SaveDistMain_Type2(connection,paramList1);

                    foreach (Dictionary<string, string> lst in obj)
                    {

                        var paramList2 = new Dictionary<string, object>
                        {
                            { "nvar_P_DISTCSSCODE", dCode },
                            { "nvar_P_MID", lst["Mid"].AsText() },
                            { "nvar_P_MGUBUN", lst["Gubun"].AsText() },
                            { "nvar_P_MPLACECODE", lst["PlaceCode"].AsText() },
                            { "nume_P_SEQ", lst["Seq"].AsInt() },
                            { "nvar_P_USEYN", lst["UseYN"].AsText() },
                            { "nvar_P_DSMDETAILPATH", lst["DetailPath"].AsText() },
                            { "nvar_P_DSMDETAILNAME", lst["DetailName"].AsText() },
                            { "nvar_P_URL", lst["Url"].AsText() },
                        };

                        DistCssService.SaveDistMenu(connection, paramList2);

                        if (HttpContext.Current.Request.Files.AllKeys.Any() && !string.IsNullOrWhiteSpace(lst["DetailName"].AsText()))
                        {
                            string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();

                            var files = HttpContext.Current.Request.Files;
                            var file = files[lst["Mid"].AsText() + "File"];
                            string fileGubun = "t";
                            if (lst["PlaceCode"].AsText().Trim() == "2")
                            {
                                fileGubun = "b";
                            }
                            var fileName =  "detail_" + fileGubun + "_" + lst["Mid"].AsText() + Path.GetExtension(file.FileName);
                            string oldFilePath = string.Empty;
                            if (lst.ContainsKey("OldMenuDetailPath")) //새로 저장하는 건은 기존 파일 path가 없다 그러므로 dictionary에서 키 존재여부를 체크해야함
                            {
                                oldFilePath = lst["OldMenuDetailPath"].AsText();
                            }

                            DistFileUpload(dCode, "Menu", uploadFolder, fileName ,oldFilePath,context, file );

                        }
                    }

                    trans.Commit();   //커밋
                }
                catch (Exception)
                {
                    trans.Rollback();
                    throw;
                }

            }
        }

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    public void DistFileUpload(string dCode, string folderName, string uploadFolder, string fileName, string oldFilePath, HttpContext context, HttpPostedFile file)
    {

        string virtualPath = String.Format("{0}/{1}/{2}/{3}/"
                                                    , uploadFolder
                                                    , "SiteManagement"
                                                    , dCode
                                                    , folderName
                                                    );

        string realPath = context.Server.MapPath(virtualPath);
        if (!string.IsNullOrWhiteSpace(oldFilePath))
        {
            FileHelper.FileDelete(context.Server.MapPath(uploadFolder + oldFilePath));

        }
        int fileSize = file.ContentLength; //업로드될 파일 크기
        int maxSize = int.Parse(ConfigurationManager.AppSettings["UploadFileMaxSize"]);
        string strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
        FileHelper.CreateDirectory(realPath);
        if (strNowFileName.Equals("false"))
        {
            HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
            HttpContext.Current.Response.End();
        }
        file.SaveAs(realPath + strNowFileName);
    }

    protected void SaveDistRoll(HttpContext context)
    {
        string dCode = context.Request.Form["DCode"].AsText();
        string seq = context.Request.Form["Seq"].AsText();
        string rName = context.Request.Form["RName"].AsText();
        string rPath= context.Request.Form["RPath"].AsText();
        string dName = context.Request.Form["DName"].AsText();
        string dPath= context.Request.Form["DPath"].AsText();
        string rUrl = context.Request.Form["RUrl"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", dCode },
            { "nvar_P_ROLLBANNERSEQ", seq },
            { "nvar_P_ROLLBANNERNAME", rName },
            { "nvar_P_ROLLBANNERPATH", rPath },
            { "nvar_P_ROLLBANNERDETAILNAME", dName },
            { "nvar_P_ROLLBANNERDETAILPATH", dPath },
            { "nvar_P_ROLLBANNERURL", rUrl },
        };

        DistCssService.SaveDistRoll(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }


    protected void SaveDistBanner(HttpContext context)
    {
        string dCode = context.Request.Form["DCode"].AsText();
        string dName = context.Request.Form["DName"].AsText();
        string url = context.Request.Form["Url"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string gubunInfo = context.Request.Form["GubunInfo"].AsText();
        string pgconfirmYN = context.Request.Form["PgconfirmYN"].AsText();
        string sslYN = context.Request.Form["SslYN"].AsText();
        string masterListData = context.Request.Form["MasterListData"].AsText();
        string categoryLandingData = context.Request.Form["CategoryLandingData"].AsText();
        var dataobj = JsonConvert.DeserializeObject<List<Dictionary<string, string>>>(masterListData);
        var dataobj2 = JsonConvert.DeserializeObject<List<Dictionary<string, string>>>(categoryLandingData);
        using (OracleConnection connection = new OracleConnection(ConfigurationManager.AppSettings["ConnectionString"]))
        {
            connection.Open();
            using (OracleTransaction trans = connection.BeginTransaction())
            {

                try
                {
                    var paramList1 = new Dictionary<string, object>
                    {
                        { "nvar_P_DISTCSSCODE", dCode },
                        { "nvar_P_DISTCSSNAME", dName },
                        { "nvar_P_ENTERURL", url },
                        { "nvar_P_COMPANYCODE", "" },
                        { "nvar_P_COMPANYNAME", "" },
                        { "nvar_P_DISTCOMPANYNAME", "" },
                        { "nvar_P_DEFALUTCSSYN", "N" },
                        { "nvar_P_GUBUN", gubun },
                        { "nvar_P_GUBUNINFO", gubunInfo },
                        { "nvar_P_PGCONFIRMYN", pgconfirmYN },
                        { "nvar_P_METATAG", "" },
                        { "nvar_P_BROWSERTAG", "" },
                        { "nvar_P_SEARCHTAG", "" },
                        { "nvar_P_DISTSSLCONFIRMYN", sslYN },
                        { "nvar_P_DISTGOOLECODE", "" },
                        { "nvar_P_DISTCUSTTELNO", "" },
                        { "nvar_P_DELFLAG", "N" },

                    };

                    DistCssService.SaveDistMain_Type2(connection,paramList1);

                    foreach (Dictionary<string, string> lst in dataobj)
                    {
                        var paramList = new Dictionary<string, object>
                        {
                            { "nvar_P_DISTCSSCODE", dCode },
                            { "nume_P_KEYSEQ", lst["KeySeq"].AsInt() },
                            { "nume_P_BANNERSEQ", lst["MasterBannerSeq"].AsInt() },
                            { "nvar_P_DISTCSSMGTROLLMASTERNAME", lst["MasterName"].AsText() },
                            { "nvar_P_ROLLMASTERFILENAME", lst["MasterFileName"].AsText() },
                            { "nvar_P_ROLLMASTERFILEPATH", lst["MasterPath"].AsText() },
                            { "nvar_P_ROLLMASTERURL", lst["MasterUrl"].AsText() },
                            { "nvar_P_DELFLAG", lst["Delflag"].AsText() },
                        };

                        DistCssService.SaveDistBanner(paramList);

                        if (HttpContext.Current.Request.Files.AllKeys.Any() && !string.IsNullOrWhiteSpace(lst["MasterFileName"].AsText()))
                        {
                            string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();

                            var files = HttpContext.Current.Request.Files;
                            var file = files[lst["MasterBannerSeq"].AsText() + "BFile"];
                            var fileName =  "b-" +  DateTime.Now.ToString("yyMMdd") +"-"+ lst["MasterBannerSeq"].AsText() + Path.GetExtension(file.FileName);
                            string oldFilePath = string.Empty;

                            if (lst.ContainsKey("BOldPath")) //새로 저장하는 건은 기존 파일 path가 없다 그러므로 dictionary에서 키 존재여부를 체크해야함
                            {
                                oldFilePath = lst["BOldPath"].AsText();
                            }
                            DistFileUpload(dCode, "Banner", uploadFolder, fileName ,oldFilePath,context, file );

                        }
                    }

                    foreach (Dictionary<string, string> lst in dataobj2)
                    {
                        string mainFileName = string.Empty;
                        string mainFilePath = string.Empty;
                        if (HttpContext.Current.Request.Files.AllKeys.Any() && !string.IsNullOrWhiteSpace(lst["LFileName"].AsText()))
                        {
                            string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();

                            var files = HttpContext.Current.Request.Files;
                            var file = files[lst["LSeq"].AsText() + "LFile"];
                            var img = System.Drawing.Image.FromStream(file.InputStream, true, true);
                            var imgSize = string.Empty;

                            if (img.Width > 1200)
                            {
                                imgSize = "L";
                            }
                            else if (img.Width > 600)
                            {
                                imgSize = "M";
                            }
                            else if (img.Width > 400)
                            {
                                imgSize = "S";
                            }
                            else if (img.Width > 300)
                            {
                                imgSize = "SS";
                            }
                            else
                            {
                                imgSize = "SS";
                            }
                            mainFileName =  "cl-" + imgSize+ "-" + DateTime.Now.ToString("yyMMdd")+"-"+lst["LSeq"].AsText() + Path.GetExtension(file.FileName);
                            mainFilePath = "/SiteManagement/" + dCode + "/CategoryLanding/" + mainFileName;


                            string oldFilePath = string.Empty;
                            if (lst.ContainsKey("LOldPath")) //새로 저장하는 건은 기존 파일 path가 없다 그러므로 dictionary에서 키 존재여부를 체크해야함
                            {
                                oldFilePath = lst["LOldPath"].AsText();
                            }
                            DistFileUpload(dCode, "CategoryLanding", uploadFolder, mainFileName ,oldFilePath,context, file );

                        }

                        if (HttpContext.Current.Request.Files.AllKeys.Any() && !string.IsNullOrWhiteSpace(lst["LDFileName"].AsText()))
                        {
                            string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();

                            var files = HttpContext.Current.Request.Files;
                            var file = files[lst["LSeq"].AsText() + "LDFile"];
                            var fileName =  "cld-"+  DateTime.Now.ToString("yyMMdd")+"-"+lst["LSeq"].AsText() + Path.GetExtension(file.FileName);
                            string oldFilePath = string.Empty;
                            if (lst.ContainsKey("LDOldPath")) //새로 저장하는 건은 기존 파일 path가 없다 그러므로 dictionary에서 키 존재여부를 체크해야함
                            {
                                oldFilePath = lst["LDOldPath"].AsText();
                            }
                            DistFileUpload(dCode, "CategoryLanding", uploadFolder, fileName ,oldFilePath,context, file );

                        }

                        var paramList2 = new Dictionary<string, object>
                        {
                            { "nvar_P_DISTCSSCODE", dCode },
                            { "nume_P_KEYSEQ", lst["KeySeq"].AsInt() },
                            { "nume_P_SEQ", lst["LSeq"].AsInt() },
                            { "nvar_P_GOODSFINALCATEGORYCODE", lst["CategoryCode"].AsText() },
                            { "nvar_P_BRANDCODE", lst["BrandCode"].AsText() },
                            { "nvar_P_LANDINGPAGENAME", mainFileName },
                            { "nvar_P_LANDINGPAGEPATH", mainFilePath },
                            { "nvar_P_LANDINGPAGEURL", lst["LUrl"].AsText() },
                            { "nvar_P_LANDINGPAGEDETAILNAME", lst["LDFileName"].AsText() },
                            { "nvar_P_LANDINGPAGEDETAILPATH", lst["LDFilePath"].AsText() },
                        };

                        DistCssService.SaveDistCategoryLanding(paramList2);


                    }
                }
                catch (Exception)
                {
                    trans.Rollback();
                    throw;
                }
            }
        }


        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void SaveDistBannerDetail(HttpContext context)
    {
        string dCode = context.Request.Form["DCode"].AsText();
        string listData = context.Request.Form["ListData"].AsText();
        var dataobj = JsonConvert.DeserializeObject<List<Dictionary<string, string>>>(listData);
        using (OracleConnection connection = new OracleConnection(ConfigurationManager.AppSettings["ConnectionString"]))
        {
            connection.Open();
            using (OracleTransaction trans = connection.BeginTransaction())
            {

                try
                {
                    foreach (Dictionary<string, string> lst in dataobj)
                    {
                        var paramList = new Dictionary<string, object>
                        {
                            { "nvar_P_DISTCSSCODE", dCode },
                            { "nume_P_MASTERSEQ", lst["MasterSeq"].AsInt() },
                            { "nume_P_SEQ", lst["Seq"].AsInt() },
                            { "nvar_P_DEFALUTROLLYN", lst["DefaultYN"].AsText() },
                            { "nvar_P_DISTCSSMGTROLLDETAILNAME", lst["DeTailName"].AsText() },
                            { "nvar_P_ROLLBANNERNAME", lst["BannerFileName"].AsText() },
                            { "nvar_P_ROLLBANNERPATH", lst["BannerFilePath"].AsText() },
                            { "nvar_P_ROLLBANNERURL", lst["BannerUrl"].AsText() },
                            { "nvar_P_ROLLBANNERDETAILNAME", lst["BannerDetailFileName"].AsText() },
                            { "nvar_P_ROLLBANNERDETAILPATH", lst["BannerDetailFilePath"].AsText() },
                            { "nvar_P_DELFLAG", lst["Delflag"].AsText() },
                        };

                        DistCssService.SaveDistBannerDetail(paramList);

                        if (HttpContext.Current.Request.Files.AllKeys.Any() && !string.IsNullOrWhiteSpace(lst["BannerFileName"].AsText()))
                        {
                            string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();

                            var files = HttpContext.Current.Request.Files;
                            var file = files[lst["Seq"].AsText() + "DFile"];
                            var fileName =  "banner-" + lst["MasterSeq"].AsInt() +"_"+lst["Seq"].AsInt() + Path.GetExtension(file.FileName);
                            string oldFilePath = string.Empty;
                            if (lst.ContainsKey("DOldPath")) //새로 저장하는 건은 기존 파일 path가 없다 그러므로 dictionary에서 키 존재여부를 체크해야함
                            {
                                oldFilePath = lst["DOldPath"].AsText();
                            }
                            DistFileUpload(dCode, "Banner", uploadFolder, fileName ,oldFilePath,context, file );

                        }

                        if (HttpContext.Current.Request.Files.AllKeys.Any() && !string.IsNullOrWhiteSpace(lst["BannerDetailFileName"].AsText()))
                        {
                            string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();

                            var files = HttpContext.Current.Request.Files;
                            var file = files[lst["Seq"].AsText() + "BDFile"];
                            var fileName =  "bannerDetail-" + lst["MasterSeq"].AsInt() +"_"+lst["Seq"].AsInt() + Path.GetExtension(file.FileName);
                            string oldFilePath = string.Empty;
                            if (lst.ContainsKey("BDOldPath")) //새로 저장하는 건은 기존 파일 path가 없다 그러므로 dictionary에서 키 존재여부를 체크해야함
                            {
                                oldFilePath = lst["BDOldPath"].AsText();
                            }
                            DistFileUpload(dCode, "Banner", uploadFolder, fileName ,oldFilePath,context, file );

                        }
                    }
                }
                catch (Exception)
                {
                    trans.Rollback();
                    throw;
                }
            }
        }


        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void SaveDistPartner(HttpContext context)
    {
        string dCode = context.Request.Form["DCode"].AsText();
        int keySeq = context.Request.Form["KeySeq"].AsInt();
        int seq = context.Request.Form["Seq"].AsInt();
        string pCaption = context.Request.Form["PCaption"].AsText();
        string pName = context.Request.Form["PName"].AsText();
        string pPath= context.Request.Form["PPath"].AsText();
        string pUrl = context.Request.Form["PUrl"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", dCode },
            { "nume_P_P_KEYSEQ", keySeq },
            { "nume_P_SEQ", seq },
            { "nvar_P_PARTNERCAPTION", pCaption },
            { "nvar_P_PARTNERNAME", pName },
            { "nvar_P_PARTNERPATH", pPath },
            { "nvar_P_PARTNERRURL", pUrl },
        };

        DistCssService.SaveDistPartner(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void SaveDistPartner_Type2(HttpContext context)
    {
        string dCode = context.Request.Form["DCode"].AsText();
        string dName = context.Request.Form["DName"].AsText();
        string url = context.Request.Form["Url"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string gubunInfo = context.Request.Form["GubunInfo"].AsText();
        string pgconfirmYN = context.Request.Form["PgconfirmYN"].AsText();
        string sslYN = context.Request.Form["SslYN"].AsText();
        string partnerData = context.Request.Form["PartnerData"].AsText();
        string dipersonData = context.Request.Form["DipersonData"].AsText();
        var partnerObj = JsonConvert.DeserializeObject<List<Dictionary<string, string>>>(partnerData);
        var dipersonObj = JsonConvert.DeserializeObject<List<Dictionary<string, string>>>(dipersonData);
        using (OracleConnection connection = new OracleConnection(ConfigurationManager.AppSettings["ConnectionString"]))
        {
            connection.Open();
            using (OracleTransaction trans = connection.BeginTransaction())
            {

                try
                {
                    var paramList1 = new Dictionary<string, object>
                    {
                        { "nvar_P_DISTCSSCODE", dCode },
                        { "nvar_P_DISTCSSNAME", dName },
                        { "nvar_P_ENTERURL", url },
                        { "nvar_P_COMPANYCODE", "" },
                        { "nvar_P_COMPANYNAME", "" },
                        { "nvar_P_DISTCOMPANYNAME", "" },
                        { "nvar_P_DEFALUTCSSYN", "N" },
                        { "nvar_P_GUBUN", gubun },
                        { "nvar_P_GUBUNINFO", gubunInfo },
                        { "nvar_P_PGCONFIRMYN", pgconfirmYN },
                        { "nvar_P_METATAG", "" },
                        { "nvar_P_BROWSERTAG", "" },
                        { "nvar_P_SEARCHTAG", "" },
                        { "nvar_P_DISTSSLCONFIRMYN", sslYN },
                        { "nvar_P_DISTGOOLECODE", "" },
                        { "nvar_P_DISTCUSTTELNO", "" },
                        { "nvar_P_DELFLAG", "N" },

                    };

                    DistCssService.SaveDistMain_Type2(connection,paramList1);

                    foreach (Dictionary<string, string> lst in partnerObj)
                    {
                        var paramList2 = new Dictionary<string, object>
                        {
                            { "nvar_P_DISTCSSCODE", dCode },
                            { "nume_P_KEYSEQ", lst["KeySeq"].AsInt() },
                            { "nume_P_SEQ",  lst["PSeq"].AsText()  },
                            { "nvar_P_PARTNERCAPTION",  lst["PCaption"].AsText()  },
                            { "nvar_P_PARTNERNAME",  lst["PName"].AsText()  },
                            { "nvar_P_PARTNERPATH",  lst["PPath"].AsText()  },
                            { "nvar_P_PARTNERRURL",  lst["PUrl"].AsText()  },
                        };
                        DistCssService.SaveDistPartner_Type2(connection, paramList2);

                        if (HttpContext.Current.Request.Files.AllKeys.Any() && !string.IsNullOrWhiteSpace(lst["PName"].AsText()))
                        {
                            string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();

                            var files = HttpContext.Current.Request.Files;
                            var file = files[lst["PSeq"].AsText() + "PFile"];
                            var fileName =  "p-" + DateTime.Now.ToString("yyMMdd") +"-"+ lst["PSeq"].AsText() + Path.GetExtension(file.FileName);
                            string oldFilePath = string.Empty;
                            if (lst.ContainsKey("POldPath")) //새로 저장하는 건은 기존 파일 path가 없다 그러므로 dictionary에서 키 존재여부를 체크해야함
                            {
                                oldFilePath = lst["POldPath"].AsText();
                            }
                            DistFileUpload(dCode, "Partner", uploadFolder, fileName ,oldFilePath,context, file );

                        }
                    }
                    foreach (Dictionary<string, string> lst in dipersonObj)
                    {
                        var paramList2 = new Dictionary<string, object>
                        {
                            { "nvar_P_DISTCSSCODE", dCode },
                            { "nume_P_KEYSEQ", lst["KeySeq"].AsInt() },
                            { "nume_P_SEQ",  lst["DSeq"].AsText()  },
                            { "nvar_P_CAPTION",  lst["DCaption"].AsText()  },
                            { "nvar_P_NAME",  lst["DName"].AsText()  },
                            { "nvar_P_PATH",  lst["DPath"].AsText()  },
                            { "nvar_P_URL",  lst["DUrl"].AsText()  },
                        };
                        DistCssService.SaveDistDiperson(connection, paramList2);

                        if (HttpContext.Current.Request.Files.AllKeys.Any() && !string.IsNullOrWhiteSpace(lst["DName"].AsText()))
                        {
                            string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();

                            var files = HttpContext.Current.Request.Files;
                            var file = files[lst["DSeq"].AsText() + "DFile"];
                            var fileName =  "d-"+ DateTime.Now.ToString("yyMMdd") +"-"+ lst["DSeq"].AsText() + Path.GetExtension(file.FileName);
                            string oldFilePath = string.Empty;
                            if (lst.ContainsKey("DOldPath")) //새로 저장하는 건은 기존 파일 path가 없다 그러므로 dictionary에서 키 존재여부를 체크해야함
                            {
                                oldFilePath = lst["DOldPath"].AsText();
                            }
                            DistFileUpload(dCode, "Partner", uploadFolder, fileName ,oldFilePath,context, file );

                        }
                    }

                    trans.Commit();   //커밋
                }
                catch (Exception)
                {
                    trans.Rollback();
                    throw;
                }

            }
        }

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void SaveDistPopup(HttpContext context)
    {
        string dCode = context.Request.Form["DCode"].AsText();
        string dName = context.Request.Form["DName"].AsText();
        string url = context.Request.Form["Url"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string gubunInfo = context.Request.Form["GubunInfo"].AsText();
        string pgconfirmYN = context.Request.Form["PgconfirmYN"].AsText();
        string sslYN = context.Request.Form["SslYN"].AsText();
        string popupData = context.Request.Form["PopupData"].AsText();
        var popupObj = JsonConvert.DeserializeObject<List<Dictionary<string, string>>>(popupData);
        using (OracleConnection connection = new OracleConnection(ConfigurationManager.AppSettings["ConnectionString"]))
        {
            connection.Open();
            using (OracleTransaction trans = connection.BeginTransaction())
            {

                try
                {
                    var paramList1 = new Dictionary<string, object>
                    {
                        { "nvar_P_DISTCSSCODE", dCode },
                        { "nvar_P_DISTCSSNAME", dName },
                        { "nvar_P_ENTERURL", url },
                        { "nvar_P_COMPANYCODE", "" },
                        { "nvar_P_COMPANYNAME", "" },
                        { "nvar_P_DISTCOMPANYNAME", "" },
                        { "nvar_P_DEFALUTCSSYN", "N" },
                        { "nvar_P_GUBUN", gubun },
                        { "nvar_P_GUBUNINFO", gubunInfo },
                        { "nvar_P_PGCONFIRMYN", pgconfirmYN },
                        { "nvar_P_METATAG", "" },
                        { "nvar_P_BROWSERTAG", "" },
                        { "nvar_P_SEARCHTAG", "" },
                        { "nvar_P_DISTSSLCONFIRMYN", sslYN },
                        { "nvar_P_DISTGOOLECODE", "" },
                        { "nvar_P_DISTCUSTTELNO", "" },
                        { "nvar_P_DELFLAG", "N" },

                    };

                    DistCssService.SaveDistMain_Type2(connection,paramList1);

                    foreach (Dictionary<string, string> lst in popupObj)
                    {
                        var paramList2 = new Dictionary<string, object>
                        {
                            { "nvar_P_DISTCSSCODE", dCode },
                            { "nume_P_KEYSEQ",  lst["KeySeq"].AsText()  },
                            { "nume_P_SEQ",  lst["Seq"].AsText()  },
                            { "nvar_P_POPUPCAPTION",  lst["Caption"].AsText()  },
                            { "nume_P_POPUPTOP",  lst["Top"].AsInt()  },
                            { "nume_P_POPUPLEFT",  lst["Left"].AsInt()  },
                            { "nume_P_POPUPWIDTH",  lst["Width"].AsInt()  },
                            { "nume_P_POPUPHEIGHT",  lst["Height"].AsInt()  },
                            { "nvar_P_POPUPNAME",  lst["Name"].AsText()  },
                            { "nvar_P_POPUPPATH",  lst["Path"].AsText() },
                            { "nvar_P_DELFLAG", lst["DelFlag"].AsText()  },
                        };
                        DistCssService.SaveDistPopup(connection, paramList2);

                        if (HttpContext.Current.Request.Files.AllKeys.Any() && !string.IsNullOrWhiteSpace(lst["Name"].AsText()))
                        {
                            string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();

                            var files = HttpContext.Current.Request.Files;
                            var file = files[lst["Seq"].AsText() + "File"];
                            var fileName =  "pop-"+ DateTime.Now.ToString("yyMMdd") +"-"+ lst["Seq"].AsText() + Path.GetExtension(file.FileName);
                            string oldFilePath = string.Empty;
                            if (lst.ContainsKey("OldPath")) //새로 저장하는 건은 기존 파일 path가 없다 그러므로 dictionary에서 키 존재여부를 체크해야함
                            {
                                oldFilePath = lst["OldPath"].AsText();
                            }
                            DistFileUpload(dCode, "Popup", uploadFolder, fileName ,oldFilePath,context, file );

                        }
                    }

                    trans.Commit();   //커밋
                }
                catch (Exception)
                {
                    trans.Rollback();
                    throw;
                }

            }
        }

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void SaveDistPopupAll(HttpContext context)
    {
        string dCode = context.Request.Form["DCode"].AsText();
        string popupData = context.Request.Form["PopupData"].AsText();
        var popupObj = JsonConvert.DeserializeObject<List<Dictionary<string, string>>>(popupData);
        using (OracleConnection connection = new OracleConnection(ConfigurationManager.AppSettings["ConnectionString"]))
        {
            connection.Open();
            using (OracleTransaction trans = connection.BeginTransaction())
            {

                try
                {
                    foreach (Dictionary<string, string> lst in popupObj)
                    {
                        var paramList2 = new Dictionary<string, object>
                        {
                            { "nvar_P_DISTCSSCODE", dCode },
                            { "nume_P_SEQ",  lst["Seq"].AsText()  },
                            { "nvar_P_POPUPCAPTION",  lst["Caption"].AsText()  },
                            { "nume_P_POPUPTOP",  lst["Top"].AsInt()  },
                            { "nume_P_POPUPLEFT",  lst["Left"].AsInt()  },
                            { "nume_P_POPUPWIDTH",  lst["Width"].AsInt()  },
                            { "nume_P_POPUPHEIGHT",  lst["Height"].AsInt()  },
                            { "nvar_P_POPUPNAME",  lst["Name"].AsText()  },
                            { "nvar_P_POPUPPATH",  lst["Path"].AsText() },
                            { "nvar_P_DELFLAG", lst["DelFlag"].AsText()  },
                        };
                        DistCssService.SaveDistPopup(connection, paramList2);

                        if (HttpContext.Current.Request.Files.AllKeys.Any() && !string.IsNullOrWhiteSpace(lst["Name"].AsText()))
                        {
                            string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();

                            var files = HttpContext.Current.Request.Files;
                            var file = files[lst["Seq"].AsText() + "File"];
                            var fileName =  "popup-"+lst["Seq"].AsText() + Path.GetExtension(file.FileName);
                            string oldFilePath = string.Empty;
                            if (lst.ContainsKey("OldPath")) //새로 저장하는 건은 기존 파일 path가 없다 그러므로 dictionary에서 키 존재여부를 체크해야함
                            {
                                oldFilePath = lst["OldPath"].AsText();
                            }
                            DistFileUpload(dCode, "Popup", uploadFolder, fileName ,oldFilePath,context, file );

                        }
                    }

                    trans.Commit();   //커밋
                }
                catch (Exception)
                {
                    trans.Rollback();
                    throw;
                }

            }
        }

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void DeleteDistRoll(HttpContext context)
    {
        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
        string dCode = context.Request.Form["DCode"].AsText();
        int seq = context.Request.Form["Seq"].AsInt();
        string filePath = context.Request.Form["FilePath"].AsText();
        string detailFilePath = context.Request.Form["DetailFilePath"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", dCode },
            { "nvar_P_SEQ", seq },

        };

        DistCssService.DeleteDistRoll(paramList);
        FileHelper.FileDelete(context.Server.MapPath(uploadFolder + filePath));
        FileHelper.FileDelete(context.Server.MapPath(uploadFolder + detailFilePath));
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void DeleteDistBanner(HttpContext context)
    {
        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
        string dCode = context.Request.Form["DCode"].AsText();
        int masterSeq = context.Request.Form["MasterSeq"].AsInt();
        int seq = context.Request.Form["Seq"].AsInt();
        string type = context.Request.Form["Type"].AsText();
        string filePath = context.Request.Form["FilePath"].AsText();
        string detailFilePath = context.Request.Form["DetailFilePath"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", dCode },
            { "nume_P_MASTERSEQ", masterSeq },
            { "nume_P_SEQ", seq },
            { "nvar_P_TYPE", type },

        };

        DistCssService.DeleteDistBanner(paramList);
        if (!string.IsNullOrWhiteSpace(filePath))
        {
            FileHelper.FileDelete(context.Server.MapPath(uploadFolder + filePath));
        }

        if (!string.IsNullOrWhiteSpace(detailFilePath))
        {
            FileHelper.FileDelete(context.Server.MapPath(uploadFolder + detailFilePath));
        }

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void DeleteDistPartner(HttpContext context)
    {
        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
        string dCode = context.Request.Form["DCode"].AsText();
        int seq = context.Request.Form["Seq"].AsInt();
        string filePath = context.Request.Form["FilePath"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", dCode },
            { "nume_P_SEQ", seq },

        };

        DistCssService.DeleteDistPartner(paramList);
        FileHelper.FileDelete(context.Server.MapPath(uploadFolder + filePath));
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void DeleteDistDiperson(HttpContext context)
    {
        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
        string dCode = context.Request.Form["DCode"].AsText();
        int seq = context.Request.Form["Seq"].AsInt();
        string filePath = context.Request.Form["FilePath"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", dCode },
            { "nume_P_SEQ", seq },

        };

        DistCssService.DeleteDistDiperson(paramList);
        FileHelper.FileDelete(context.Server.MapPath(uploadFolder + filePath));
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void DeleteDistPopup(HttpContext context)
    {
        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
        string dCode = context.Request.Form["DCode"].AsText();
        int seq = context.Request.Form["Seq"].AsInt();
        string filePath = context.Request.Form["FilePath"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", dCode },
            { "nume_P_SEQ", seq },

        };

        DistCssService.DeleteDistPopup(paramList);
        FileHelper.FileDelete(context.Server.MapPath(uploadFolder + filePath));
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void DeleteDistAll(HttpContext context)
    {
        string dCode = context.Request.Form["DCode"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", dCode },

        };

        DistCssService.DeleteDistAll(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void GetSubMenuList(HttpContext context)
    {
        string dCode = context.Request.Form["Dcode"].AsText();
        string upCode = context.Request.Form["MenuUpCode"].AsText();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", dCode},
            { "nvar_P_MENUUPCODE", upCode},

        };

        var list = DistCssService.GetSubMenuList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void DeleteDistMgtImg(HttpContext context)
    {
        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
        string dCode = context.Request.Form["DCode"].AsText();
        string type = context.Request.Form["Type"].AsText();
        string deleteFilePath = context.Request.Form["DeleteFilePath"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", dCode },
            { "nvar_P_TYPE", type },

        };

        DistCssService.DeleteDistMgtImg(paramList);

        FileHelper.FileDelete(context.Server.MapPath(uploadFolder + deleteFilePath));
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void DeleteMenuImg(HttpContext context)
    {
        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
        string dCode = context.Request.Form["DCode"].AsText();
        string menuId = context.Request.Form["MenuId"].AsText();
        string type = context.Request.Form["Type"].AsText();
        string deleteFilePath = context.Request.Form["DeleteFilePath"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", dCode },
            { "nvar_P_MENUID", menuId },
            { "nvar_P_TYPE", type },

        };

        DistCssService.DeleteDistMenuImg(paramList);
        FileHelper.FileDelete(context.Server.MapPath(uploadFolder + deleteFilePath));
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void DeleteBannerImg(HttpContext context)
    {
        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
        string dCode = context.Request.Form["DCode"].AsText();
        int seq = context.Request.Form["Seq"].AsInt();
        string deleteFilePath = context.Request.Form["DeleteFilePath"].AsText();
        string type = context.Request.Form["Type"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", dCode },
            { "nvar_P_SEQ", seq },
            { "nvar_P_TYPE", type },

        };

        DistCssService.DeleteDistRollImg(paramList);
        FileHelper.FileDelete(context.Server.MapPath(uploadFolder + deleteFilePath));
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void DeleteDistBannerImg(HttpContext context)
    {
        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
        string dCode = context.Request.Form["DCode"].AsText();
        int masterseq = context.Request.Form["MSeq"].AsInt();
        int seq = context.Request.Form["Seq"].AsInt();
        string deleteFilePath = context.Request.Form["DeleteFilePath"].AsText();
        string type = context.Request.Form["Type"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", dCode },
            { "nume_P_MASTERSEQ", masterseq },
            { "nume_P_SEQ", seq },
            { "nvar_P_TYPE", type },

        };

        DistCssService.DeleteDistBannerImg(paramList);
        FileHelper.FileDelete(context.Server.MapPath(uploadFolder + deleteFilePath));
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void DeletePartnerImg(HttpContext context)
    {
        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
        string dCode = context.Request.Form["DCode"].AsText();
        int seq = context.Request.Form["Seq"].AsInt();
        string deleteFilePath = context.Request.Form["DeleteFilePath"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", dCode },
            { "nvar_P_SEQ", seq },
        };

        DistCssService.DeleteDistPartnerImg(paramList);
        FileHelper.FileDelete(context.Server.MapPath(uploadFolder + deleteFilePath));
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void DeleteDipersonImg(HttpContext context)
    {
        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
        string dCode = context.Request.Form["DCode"].AsText();
        int seq = context.Request.Form["Seq"].AsInt();
        string deleteFilePath = context.Request.Form["DeleteFilePath"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", dCode },
            { "nvar_P_SEQ", seq },
        };

        DistCssService.DeleteDistDipersonImg(paramList);
        FileHelper.FileDelete(context.Server.MapPath(uploadFolder + deleteFilePath));
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void DeletePopupImg(HttpContext context)
    {
        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
        string dCode = context.Request.Form["DCode"].AsText();
        int seq = context.Request.Form["Seq"].AsInt();
        string deleteFilePath = context.Request.Form["DeleteFilePath"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_DISTCSSCODE", dCode },
            { "nvar_P_SEQ", seq },
        };

        DistCssService.DeleteDistPopupImg(paramList);
        FileHelper.FileDelete(context.Server.MapPath(uploadFolder + deleteFilePath));
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }


    //protected void GetNextDistCssMasterRollSeq(HttpContext context)
    //{
    //    int nextSeq = DistCssService.GetNextDistCssMasterRollSeq();
    //    HttpContext.Current.Response.ContentType = "text/plain";
    //    HttpContext.Current.Response.Write(nextSeq);
    //}


    //protected void GetNextDistCssCategoryLandingSeq(HttpContext context)
    //{
    //    int nextSeq = DistCssService.GetNextDistCssCategoryLandingSeq();
    //    HttpContext.Current.Response.ContentType = "text/plain";
    //    HttpContext.Current.Response.Write(nextSeq);
    //}

    //protected void GetNextDistCssPartnerSeq(HttpContext context)
    //{
    //    int nextSeq = DistCssService.GetNextDistCssPartnerSeq();
    //    HttpContext.Current.Response.ContentType = "text/plain";
    //    HttpContext.Current.Response.Write(nextSeq);
    //}

    //protected void GetNextDistCssDipersonSeq(HttpContext context)
    //{
    //    int nextSeq = DistCssService.GetNextDistCssDipersonSeq();
    //    HttpContext.Current.Response.ContentType = "text/plain";
    //    HttpContext.Current.Response.Write(nextSeq);
    //}

    public bool IsReusable {
        get {
            return false;
        }
    }

}