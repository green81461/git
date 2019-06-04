<%@ WebHandler Language="C#" Class="FileUploadHandler" %>

using System;
using System.Web;
using System.Collections.Generic;
using Urian.Core;
using SocialWith.Biz.Wish;
using NLog;
using System.Configuration;
using System.Linq;
using System.IO;
public class FileUploadHandler : IHttpHandler
{

    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    public void ProcessRequest(HttpContext context)
    {

        string method = context.Request.Form["Method"].AsText();
        switch (method)
        {

            case "NewGoodFileUpload": // 신규견적요청
                NewGoodFileUpload(context);
                break;
            case "GoodsFileUpload": //상품등록
                GoodsFileUpload(context);
                break;
            case "LoanDocFileUpload": //[관리자] 회사관리 - 여신문서
                GoodsLoanDocFileUpload(context);
                break;
            case "DistFileUpload": //[관리자] 사이트 관리  파일 업로드
                DistFileUpload(context);
                break;
            case "DistMenuFileUpload": //[관리자] 사이트 관리 메뉴 파일 업로드
                DistMenuFileUpload(context);
                break;
            case "DistBannerFileUpload": //[관리자] 사이트 관리 배너 파일 업로드
                DistBannerFileUpload(context);
                break;
            case "DistPartnerFileUpload": //[관리자] 사이트 관리 협력사 파일 업로드
                DistPartnerFileUpload(context);
                break;
            case "DistFileUpload_Type2": //[관리자] 사이트 관리  파일 업로드
                DistFileUpload_Type2(context);
                break;
            default:
                break;
        }

    }

    protected void NewGoodFileUpload(HttpContext context) {

        if (HttpContext.Current.Request.Files.AllKeys.Any())
        {
            SocialWith.Biz.Board.BoardService Service = new SocialWith.Biz.Board.BoardService();
            var httpPostedFile = HttpContext.Current.Request.Files["UploadFile"];
            if (httpPostedFile != null)
            {
                string svidAttach = context.Request.Form["SvidAttach"].AsText();
                string userId = context.Request.Form["UserId"].AsText();
                string code = context.Request.Form["Code"].AsText();
                int index = context.Request.Form["Index"].AsInt();
                string type = context.Request.Form["Type"].AsText();
                string fileName = Path.GetFileName(httpPostedFile.FileName); //업로드될 파일명
                int fileSize = httpPostedFile.ContentLength; //업로드될 파일 크기
                string ext = Path.GetExtension(httpPostedFile.FileName); //확장자
                string strFilePath = context.Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
                string filePath = "\\"+type+"\\" + userId + "\\"+ code + "\\";
                string iFileName = userId + "_" + fileName; //논리파일명
                var paramList = new Dictionary<string, object>
                {
                    //첨부파일
                    {"nvar_P_SVID_ATTACH", svidAttach},
                    {"nvar_P_SVID_BOARD", code},
                    {"nume_P_ATTACH_NO", 1 },
                    {"nvar_P_ATTACH_P_NAME",fileName },
                    {"nvar_P_ATTACH_I_NAME",iFileName },
                    {"nvar_P_ATTACH_EXT", ext},
                    {"nume_P_ATTACH_DOWNCNT",0 },
                    {"nvar_P_ATTACH_SIZE", fileSize },
                    {"nvar_P_ATTACH_PATH", filePath }
                };
                Service.SaveBoardAttach(paramList);       //파일 DB 저장

                string virtualPath = String.Format("{0}/{1}/{2}/{3}/"
                                                   , ConfigurationManager.AppSettings["UpLoadFolder"]
                                                   , type
                                                   , userId
                                                   , code
                                                   );
                string realPath = context.Server.MapPath(virtualPath);
                int maxSize = int.Parse(ConfigurationManager.AppSettings["UploadFileMaxSize"]);
                string strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                httpPostedFile.SaveAs(realPath + fileName);
            }
        }

    }
    protected void GoodsFileUpload(HttpContext context) {

        if (HttpContext.Current.Request.Files.AllKeys.Any())
        {
            SocialWith.Biz.Board.BoardService Service = new SocialWith.Biz.Board.BoardService();
            string type = context.Request.Form["Type"].AsText();
            string categoryCode = context.Request.Form["CategoryCode"].AsText();
            string groupCode = context.Request.Form["GroupCode"].AsText();
            string goodsCode = context.Request.Form["GoodsCode"].AsText();
            string virtualPath = String.Format("{0}/{1}/{2}/{3}/{4}/"
                                                    , ConfigurationManager.AppSettings["UpLoadFolder"]
                                                    , type
                                                    , categoryCode
                                                    , groupCode
                                                    , goodsCode
                                                    );
            //string realPath = context.Server.MapPath(virtualPath);
            string realPath = @"D:\GoodsImage\" + categoryCode + @"\" + groupCode + @"\" + goodsCode + @"\";
            int maxSize = int.Parse(ConfigurationManager.AppSettings["UploadFileMaxSize"]);
            string fileName = string.Empty;
            int fileSize = 0;
            string strNowFileName = string.Empty;
            var httpPostedFile1 = HttpContext.Current.Request.Files["UploadFile1"];
            if (httpPostedFile1 != null)
            {
                fileName = categoryCode + "-" + groupCode + "-" + goodsCode + "-fff.jpg";
                //fileName = Path.GetFileName(httpPostedFile1.FileName); //업로드될 파일명
                fileSize = httpPostedFile1.ContentLength; //업로드될 파일 크기
                strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                httpPostedFile1.SaveAs(realPath + fileName);
            }

            var httpPostedFile2 = HttpContext.Current.Request.Files["UploadFile2"];
            if (httpPostedFile2 != null)
            {

                fileName = categoryCode + "-" + groupCode + "-" + goodsCode + "-mmm.jpg";
                //fileName = Path.GetFileName(httpPostedFile2.FileName); //업로드될 파일명
                fileSize= httpPostedFile2.ContentLength; //업로드될 파일 크기
                strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                httpPostedFile2.SaveAs(realPath + fileName);
            }

            var httpPostedFile3 = HttpContext.Current.Request.Files["UploadFile3"];
            if (httpPostedFile3 != null)
            {

                fileName = categoryCode + "-" + groupCode + "-" + goodsCode + "-sss.jpg";
                //fileName = Path.GetFileName(httpPostedFile3.FileName); //업로드될 파일명
                fileSize= httpPostedFile3.ContentLength; //업로드될 파일 크기
                strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                httpPostedFile3.SaveAs(realPath + fileName);
            }

            var httpPostedFile4 = HttpContext.Current.Request.Files["UploadFile4"];
            if (httpPostedFile4 != null)
            {
                fileName = categoryCode + "-" + groupCode + "-" + goodsCode + "-ddd1.jpg";
                //fileName = Path.GetFileName(httpPostedFile4.FileName); //업로드될 파일명
                fileSize= httpPostedFile4.ContentLength; //업로드될 파일 크기
                strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                httpPostedFile4.SaveAs(realPath + fileName);
            }

            var httpPostedFile5 = HttpContext.Current.Request.Files["UploadFile5"];
            if (httpPostedFile5 != null)
            {
                fileName = categoryCode + "-" + groupCode + "-" + goodsCode + "-ddd2.jpg";
                //fileName = Path.GetFileName(httpPostedFile5.FileName); //업로드될 파일명
                fileSize= httpPostedFile1.ContentLength; //업로드될 파일 크기
                strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                httpPostedFile5.SaveAs(realPath + fileName);
            }

            var httpPostedFile6 = HttpContext.Current.Request.Files["UploadFile6"];
            if (httpPostedFile6 != null)
            {

                fileName = categoryCode + "-" + groupCode + "-" + goodsCode + "-ddd3.jpg";
                //fileName = Path.GetFileName(httpPostedFile6.FileName); //업로드될 파일명
                fileSize= httpPostedFile6.ContentLength; //업로드될 파일 크기
                strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                httpPostedFile6.SaveAs(realPath + fileName);
            }
            var httpPostedFile7 = HttpContext.Current.Request.Files["UploadFile7"];
            if (httpPostedFile7 != null)
            {
                fileName = categoryCode + "-" + groupCode + "-" + goodsCode + "-ddd4.jpg";
                //fileName = Path.GetFileName(httpPostedFile6.FileName); //업로드될 파일명
                fileSize= httpPostedFile7.ContentLength; //업로드될 파일 fileName
                strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                httpPostedFile7.SaveAs(realPath + fileName);
            }
        }
    }

    //[관리자] 회사관리 - 여신문서
    protected void GoodsLoanDocFileUpload(HttpContext context) {

        if (HttpContext.Current.Request.Files.AllKeys.Any())
        {
            //SocialWith.Biz.Board.BoardService Service = new SocialWith.Biz.Board.BoardService();
            SocialWith.Biz.Comapny.CompanyService companyService = new SocialWith.Biz.Comapny.CompanyService();
            var httpPostedFile = HttpContext.Current.Request.Files["UploadFile"];
            if (httpPostedFile != null)
            {
                string compCode = context.Request.Form["CompCode"].AsText();
                int docNo = context.Request.Form["DocNo"].AsInt();
                string mapCode = context.Request.Form["MapCode"].AsText();
                int commChanel = context.Request.Form["CommChanel"].AsInt();
                int commType = context.Request.Form["CommType"].AsInt();
                string gubun = context.Request.Form["Gubun"].AsText(); //회사구분(A:판매사, B:구매사)
                string type = context.Request.Form["Type"].AsText();

                string svidAttach = Guid.NewGuid().ToString();
                //string userId = context.Request.Form["UserId"].AsText();
                //string code = context.Request.Form["Code"].AsText();
                //int index = context.Request.Form["Index"].AsInt();

                string fileName = Path.GetFileName(httpPostedFile.FileName); //업로드될 파일명
                int fileSize = httpPostedFile.ContentLength; //업로드될 파일 크기
                string ext = Path.GetExtension(httpPostedFile.FileName); //확장자
                string strFilePath = context.Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기
                string filePath = "\\"+type+"\\" + gubun + "\\"+ compCode + "\\";
                string iFileName = compCode + "_" + fileName; //논리파일명

                var paramList = new Dictionary<string, object>
                {
                    //제출서류정보
                    { "nvar_P_COMPANY_CODE", compCode },
                    { "nume_P_DOC_NO", docNo },
                    { "nvar_P_MAP_CODE", mapCode },
                    { "nume_P_COMM_CHANEL", commChanel },
                    { "nume_P_COMM_TYPE", commType },
                    //첨부파일
                    {"nvar_P_SVID_ATTACH", svidAttach},
                    //{"nvar_P_SVID_BOARD", compCode},
                    //{"nume_P_ATTACH_NO", docNo },
                    {"nvar_P_ATTACH_P_NAME",fileName },
                    {"nvar_P_ATTACH_I_NAME",iFileName },
                    {"nvar_P_ATTACH_EXT", ext},
                    {"nume_P_ATTACH_DOWNCNT",0 },
                    {"nvar_P_ATTACH_SIZE", fileSize.AsText() },
                    {"nvar_P_ATTACH_PATH", filePath }
                };
                //Service.SaveBoardAttach(paramList);       //파일 DB 저장
                companyService.SaveGoodsLoanDoc(paramList); //여신문서정보 및 파일 저장

                string virtualPath = String.Format("{0}/{1}/{2}/{3}/"
                                                   , ConfigurationManager.AppSettings["UpLoadFolder"]
                                                   , type
                                                   , gubun
                                                   , compCode
                                                   );
                string realPath = context.Server.MapPath(virtualPath);
                int maxSize = int.Parse(ConfigurationManager.AppSettings["UploadFileMaxSize"]);
                string strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                httpPostedFile.SaveAs(realPath + fileName);
            }
        }
    }
    protected void DistFileUpload(HttpContext context) {

        if (HttpContext.Current.Request.Files.AllKeys.Any())
        {
            string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
            string dCode = context.Request.Form["DCode"].AsText();
            string virtualPath = String.Format("{0}/{1}/{2}/"
                                                    , uploadFolder
                                                    , "SiteManagement"
                                                    , dCode
                                                    );
            string realPath = context.Server.MapPath(virtualPath);
            int maxSize = int.Parse(ConfigurationManager.AppSettings["UploadFileMaxSize"]);

            int fileSize = 0;
            string strNowFileName = string.Empty;
            var favicon = HttpContext.Current.Request.Files["Favicon"];


            if (favicon != null)
            {
                string oldFilePath = context.Request.Form["OldFaviconFilePath"];

                FileHelper.FileDelete(context.Server.MapPath(uploadFolder + oldFilePath));
                //string fileName = Path.GetFileName(favicon.FileName);
                string fileName = "mini_logo.png";
                fileSize = favicon.ContentLength; //업로드될 파일 크기
                strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                favicon.SaveAs(realPath + strNowFileName);
            }

            var css = HttpContext.Current.Request.Files["Css"];
            if (css != null)
            {
                string oldFilePath = context.Request.Form["OldCssFilePath"];
                FileHelper.FileDelete(context.Server.MapPath(uploadFolder + oldFilePath));
                fileSize = css.ContentLength; //업로드될 파일 크기
                //string fileName = Path.GetFileName(css.FileName);
                string fileName = "SiteInfo.css";
                strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                css.SaveAs(realPath + strNowFileName);
            }

            var topLogo = HttpContext.Current.Request.Files["TopLogo"];
            if (topLogo != null)
            {
                string oldFilePath = context.Request.Form["OldTopLogoFilePath"];
                FileHelper.FileDelete(context.Server.MapPath(uploadFolder + oldFilePath));
                fileSize = topLogo.ContentLength; //업로드될 파일 크기
                //string fileName = Path.GetFileName(topLogo.FileName);
                string fileName = "main_logo.png";
                strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                topLogo.SaveAs(realPath + strNowFileName);
            }

            var bottomLogo = HttpContext.Current.Request.Files["BottomLogo"];
            if (bottomLogo != null)
            {
                string oldFilePath = context.Request.Form["OldBottomLogoFilePath"];
                FileHelper.FileDelete(context.Server.MapPath(uploadFolder + oldFilePath));
                fileSize = bottomLogo.ContentLength; //업로드될 파일 크기
                //string fileName = Path.GetFileName(bottomLogo.FileName);
                string fileName = "main_bottom_logo.png";
                strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                bottomLogo.SaveAs(realPath + strNowFileName);
            }

            var copyRight = HttpContext.Current.Request.Files["CopyRight"];
            if (copyRight != null)
            {
                string oldFilePath = context.Request.Form["OldCopyFilePath"];
                FileHelper.FileDelete(context.Server.MapPath(uploadFolder + oldFilePath));
                fileSize = copyRight.ContentLength; //업로드될 파일 크기
                //string fileName = Path.GetFileName(copyRight.FileName);
                string fileName = "copyright.png";
                strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                copyRight.SaveAs(realPath + strNowFileName);
            }

        }
    }

    protected void DistMenuFileUpload(HttpContext context) {

        if (HttpContext.Current.Request.Files.AllKeys.Any())
        {
            string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
            string dCode = context.Request.Form["Dcode"].AsText();
            string gubun = context.Request.Form["Gubun"].AsText();
            string mid = context.Request.Form["Mid"].AsText();
            string virtualPath = String.Format("{0}/{1}/{2}/"
                                                    , uploadFolder
                                                    , "SiteManagement"
                                                    , dCode
                                                    );
            string realPath = context.Server.MapPath(virtualPath);
            int maxSize = int.Parse(ConfigurationManager.AppSettings["UploadFileMaxSize"]);

            int fileSize = 0;
            string strNowFileName = string.Empty;
            var mainFile = HttpContext.Current.Request.Files["MainFile"];
            if (mainFile != null)
            {
                //string fileName = Path.GetFileName(mainFile.FileName);
                string fileName = "main_" + gubun + "_" + mid + ".jpg";
                string oldFilePath =context.Request.Form["OldMainFilePath"];
                FileHelper.FileDelete(context.Server.MapPath(uploadFolder + oldFilePath));
                fileSize = mainFile.ContentLength; //업로드될 파일 크기
                strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                mainFile.SaveAs(realPath + strNowFileName);
            }

            var detailFile = HttpContext.Current.Request.Files["DetailFile"];

            if (detailFile != null)
            {
                string oldFilePath = context.Request.Form["OldDetailFilePath"];
                //string fileName = Path.GetFileName(mainFile.FileName);
                string fileName = "detail_" + gubun + "_" + mid + ".jpg";
                FileHelper.FileDelete(context.Server.MapPath(uploadFolder + oldFilePath));
                fileSize = detailFile.ContentLength; //업로드될 파일 크기
                strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                detailFile.SaveAs(realPath + strNowFileName);
            }
        }
    }

    protected void DistBannerFileUpload(HttpContext context) {

        if (HttpContext.Current.Request.Files.AllKeys.Any())
        {
            SocialWith.Biz.Board.BoardService Service = new SocialWith.Biz.Board.BoardService();
            string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
            string dCode = context.Request.Form["DCode"].AsText();
            string seq = context.Request.Form["Seq"].AsText();
            string virtualPath = String.Format("{0}/{1}/{2}/"
                                                    , uploadFolder
                                                    , "SiteManagement"
                                                    , dCode
                                                    );
            string realPath = context.Server.MapPath(virtualPath);
            int maxSize = int.Parse(ConfigurationManager.AppSettings["UploadFileMaxSize"]);

            int fileSize = 0;
            string strNowFileName = string.Empty;
            var mainFile = HttpContext.Current.Request.Files["MainFile"];
            if (mainFile != null)
            {
                string oldFilePath = context.Request.Form["OldFilePath"];
                FileHelper.FileDelete(context.Server.MapPath(uploadFolder + oldFilePath));
                string fileName = Path.GetFileName(mainFile.FileName);
                fileSize = mainFile.ContentLength; //업로드될 파일 크기
                strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                mainFile.SaveAs(realPath + strNowFileName);
            }

            var detailFile = HttpContext.Current.Request.Files["DetailFile"];

            if (detailFile != null)
            {
                string oldFilePath = context.Request.Form["OldDetailFilePath"];
                string fileName = Path.GetFileName(detailFile.FileName);
                FileHelper.FileDelete(context.Server.MapPath(uploadFolder + oldFilePath));
                fileSize = detailFile.ContentLength; //업로드될 파일 크기
                strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                detailFile.SaveAs(realPath + strNowFileName);
            }

        }
    }

    protected void DistPartnerFileUpload(HttpContext context) {

        if (HttpContext.Current.Request.Files.AllKeys.Any())
        {
            SocialWith.Biz.Board.BoardService Service = new SocialWith.Biz.Board.BoardService();
            string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
            string dCode = context.Request.Form["DCode"].AsText();
            string virtualPath = String.Format("{0}/{1}/{2}/"
                                                    , uploadFolder
                                                    , "SiteManagement"
                                                    , dCode
                                                    );
            string realPath = context.Server.MapPath(virtualPath);
            int maxSize = int.Parse(ConfigurationManager.AppSettings["UploadFileMaxSize"]);

            int fileSize = 0;
            string strNowFileName = string.Empty;
            var mainFile = HttpContext.Current.Request.Files["MainFile"];
            if (mainFile != null)
            {
                string oldFilePath = context.Request.Form["OldFilePath"];
                FileHelper.FileDelete(context.Server.MapPath(uploadFolder + oldFilePath));
                string fileName = Path.GetFileName(mainFile.FileName);
                fileSize = mainFile.ContentLength; //업로드될 파일 크기
                strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
                FileHelper.CreateDirectory(realPath);
                if (strNowFileName.Equals("false"))
                {
                    HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
                    HttpContext.Current.Response.End();
                }
                mainFile.SaveAs(realPath + strNowFileName);
            }

        }
    }

    protected void DistFileUpload_Type2(HttpContext context) {

        if (HttpContext.Current.Request.Files.AllKeys.Any())
        {
            string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
            string dCode = context.Request.Form["DCode"].AsText();
            string virtualPath = string.Empty;
            string realPath = string.Empty;
            string strNowFileName = string.Empty;
            var favicon = HttpContext.Current.Request.Files["Favicon"];
            if (favicon != null)
            {
                DistFileUpload(dCode,"Main", uploadFolder,"mini_logo" + Path.GetExtension(favicon.FileName),"OldFaviconPath", context, favicon);
            }

            var css = HttpContext.Current.Request.Files["Css"];
            if (css != null)
            {

                DistFileUpload(dCode,"Main", uploadFolder,"SiteInfo" + Path.GetExtension(css.FileName),"OldCssPath", context, css);
            }

            var topLogo = HttpContext.Current.Request.Files["TopLogo"];
            if (topLogo != null)
            {
                DistFileUpload(dCode,"Main", uploadFolder,"main_logo" + Path.GetExtension(topLogo.FileName),"OldTopLogoPath", context, topLogo);
            }

            var bottomLogo = HttpContext.Current.Request.Files["BottomLogo"];
            if (bottomLogo != null)
            {
                DistFileUpload(dCode,"Main", uploadFolder,"main_bottom_logo" + Path.GetExtension(bottomLogo.FileName),"OldBottomLogoPath", context, bottomLogo);
            }

            var copyRight = HttpContext.Current.Request.Files["CopyRight"];
            if (copyRight != null)
            {
                DistFileUpload(dCode,"Main", uploadFolder,"copyright" + Path.GetExtension(copyRight.FileName),"OldCopyPath", context, copyRight);
            }

            var topBanner = HttpContext.Current.Request.Files["TopBanner"];
            if (topBanner != null)
            {
                DistFileUpload(dCode,"Main", uploadFolder,"top_banner" +Path.GetExtension(topBanner.FileName),"OldTopBannerPath", context, topBanner);
            }

            var topBannerDetail = HttpContext.Current.Request.Files["TopBannerDetail"];
            if (topBannerDetail != null)
            {
                DistFileUpload(dCode,"Main", uploadFolder,"top_banner_detail" + Path.GetExtension(topBannerDetail.FileName),"OldTopBannerDetailPath", context, topBannerDetail);
            }

            var loginFavicon = HttpContext.Current.Request.Files["LoginFavicon"];
            if (loginFavicon != null)
            {
                DistFileUpload(dCode,"Login", uploadFolder,"loginFavicon" + Path.GetExtension(loginFavicon.FileName),"OldLoginFaviconPath", context, loginFavicon);
            }

            var loginTBaner = HttpContext.Current.Request.Files["LoginTBanner"];
            if (loginTBaner != null)
            {
                DistFileUpload(dCode,"Login", uploadFolder,"login_topbanner" + Path.GetExtension(loginTBaner.FileName),"OldLoginTbannerPath", context, loginTBaner);
            }

            var loginBg = HttpContext.Current.Request.Files["LoginBg"];
            if (loginBg != null)
            {
                DistFileUpload(dCode,"Login", uploadFolder,"login_bg" + Path.GetExtension(loginBg.FileName),"OldLoginBgPath", context, loginBg);
            }

            var loginCompLogo = HttpContext.Current.Request.Files["LoginCompLogo"];
            if (loginCompLogo != null)
            {
                DistFileUpload(dCode,"Login", uploadFolder,"login_compLogo" + Path.GetExtension(loginCompLogo.FileName),"OldLoginCompLogoPath", context, loginCompLogo);
            }

            var loginCopy = HttpContext.Current.Request.Files["LoginCopy"];
            if (loginCopy != null)
            {
                DistFileUpload(dCode,"Login", uploadFolder,"login_copyright" + Path.GetExtension(loginCopy.FileName),"OldLoginCopyPath", context, loginCopy);
            }


        }
    }

    public void DistFileUpload(string dCode, string folderName, string uploadFolder, string fileName, string oldFilePath, HttpContext context, HttpPostedFile file) {

        string virtualPath = String.Format("{0}/{1}/{2}/{3}/"
                                                    , uploadFolder
                                                    , "SiteManagement"
                                                    , dCode
                                                    , folderName
                                                    );

        string realPath = context.Server.MapPath(virtualPath);
        FileHelper.FileDelete(context.Server.MapPath(uploadFolder + context.Request.Form[oldFilePath]));
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
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}