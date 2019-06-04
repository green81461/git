<%@ WebHandler Language="C#" Class="CompanyHandler" %>

using NLog;
using System;
using System.Web;
using System.Collections.Generic;
using System.Configuration;
using SocialWith.Biz.Comapny;
using Newtonsoft.Json;
using Urian.Core;
using SocialWith.Data.Company;
using SocialWith.Biz.Order;
using SocialWith.Biz.User;
using SocialWith.Biz.Goods;
using SocialWith.Biz.Pay;

// 회사코드 관련 기능
public class CompanyHandler : IHttpHandler
{

    #region << logger >>
    private static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    private static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    private static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    private static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    private static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    private static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    protected CompanyService CompanyService = new CompanyService();
    protected UserService UserService = new UserService();
    protected OrderService OrderService = new OrderService();
    protected GoodsService GoodsService = new GoodsService();
    protected PayService PayService = new PayService();

    public void ProcessRequest(HttpContext context)
    {

        string flag = context.Request.Form["Flag"];

        switch (flag)
        {
            case "List":    // 회사코드 목록 조회
                GetCompanyList(context, "");
                break;
            case "ListByGubunCompNo":    // 회사코드 목록 조회 - 구분 및 사업자번호별
                GetCompanyList_GubnCompNo(context, "");
                break;
            case "Create":  // 회사코드 생성
                CompanyCodeGenerate(context);
                break;
            case "Update":  // 회사명, 비고 수정
                CompanyNameUpdate(context);
                break;
            case "GetSaleCompanyDocumentInfo":  // 판매사 문서리스트(주문내역조회)
                GetSaleCompanyDocumentInfo(context);
                break;
            case "BorderTypeMgt":  // 구매사 주문 유형 관리
                BorderTypeMgt(context);
                break;
            case "GetSaleCompanyList": //판매사 리스트(상품수정용) 
                GetSaleCompanyList(context);
                break;
            case "GetSupplyCompanyList": //공급사 리스트(상품수정용) 
                GetSupplyCompanyList(context);
                break;
            case "CompanyManagementList": //회사관리 리스트
                GetCompanyManagementList(context);
                break;
            case "CompanyManagementListCount": //회사관리 리스트 카운트 조회
                GetCompanyManagementListCount(context);
                break;
            case "CompanyMngtInfo_Admin": //회사관리Info
                GetCompanyMngtInfo_Admin(context);
                break;
            case "SaveCompMngt":    //[관리자] 회사관리 저장
                SaveCompanyMngt_Admin(context);
                break;
            case "GetBTypeRoleList": //[selectbox용]구매사 결제유형 조회
                GetBTypeRoleList(context);
                break;
            case "SupComUdateList": //공급사 리스트(상품수정용) 
                SupComUdateList(context);
                break;
            case "GetLoanDocList": //회사 여신 문서 조회
                GetGoodsLoanDocList(context);
                break;
            case "DelLoanDoc": //회사 여신 문서 삭제
                DeleteGoodsLoanDoc(context);
                break;
            case "CheckComNo":
                CheckComNo(context);
                break;
            case "GetSocialCompLinkInfo":
                GetSocialCompLinkInfo(context);
                break;
            case "GetSocialCompUserLinkInfo":
                GetSocialCompUserLinkInfo(context);
                break;
            case "GetGoodsPriceCompareSaleCompInfo":
                GetGoodsPriceCompareSaleCompInfo(context);
                break;
            case "CompList_A":
                GetCompanyList_A(context); //판매사 조회
                break;
            case "SaveOrdSaleComp":
                SaveOrderSaleComp(context); //주문 업체 저장
                break;
            case "GetGroupSaleCompList":
                GetGroupSaleCompList(context); //그룹 판매사 리스트 조회
                break;
            case "GetCompPriceCompanyList":
                GetCompPriceCompanyList(context); //[관리자]단가조회화면 업체조회
                break;
            case "GetCompDisplayCompanyList":
                GetCompDisplayCompanyList(context); //[관리자]Display조회화면 업체조회
                break;
            case "GetTypeACompCountByCompNo":
                GetTypeACompCountByCompNo(context);  //[판매사 회원가입시]사업자번호로 가입된 회사가 존재하는지 체크
                break;
            case "GetCompCountByCompNoUrl":
                GetCompCountByCompNoUrl(context);  //[구매사 회원가입시]접속 Url과 사업자번호로 가입된 회사가 존재하는지 체크
                break;
            case "GetCompListByGubun":
                GetCompanyListByGubun(context); //판매사 조회
                break;
            case "GetCompListByAdminId":
                GetCompanyListByAdminId(context); //판매사 조회
                break;
            case "GetCompanySearchList":
                GetCompanySearchList(context); //기본 회사 검색
                break;
            case "GetLastNoneComNoCode":
                GetLastNoneComNoCode(context); //사업자번호없음코드 생성
                break;
            case "InsertRmpCompPrice":
                InsertRmpCompPrice(context); //RMP 가격 등록
                break;
            case "GetRmpCompPriceList":
                GetRmpCompPriceList(context); //RMP가격관리 리스트
                break;
            case "UpdateRmpCompPrice":
                UpdateRmpCompPrice(context); // 사용유무 업데이트
                break;
            case "GetOrderSaleCompPopup_Admin":
                GetOrderSaleCompPopup_Admin(context); //관리자 주문연동관리 주문업체조회 팝업
                break;
            case "GetPGList":   // PG리스트 조회
                GetPGRegisterCompList(context);
                break;
            case "GetPGDetail": // PG리스트 상세조회
                GetPGCompDetail(context);
                break;
            case "GetPGUpt":    // PG리스트 수정
                UpdatePGCompInfo(context);
                break;
            case "GetSearchCompanyList":    // 주문관리 정산내역조회 전자세금계산 최종현황 회사조회
                GetSearchCompanyList(context);
                break;
            case "GetSalesExactcal":    // 판매사 정산내역조회
                GetSalesExactcal(context);
                break;
            default:
                break;
        }
    }

    protected void UpdatePGCompInfo(HttpContext context)
    {
        String SvidUser = context.Request.Form["SvidUser"].AsText().Trim();
        String CompCode = context.Request.Form["CompCode"].AsText().Trim();
        String CompNo = context.Request.Form["CompNo"].AsText().Trim();
        String AId = context.Request.Form["AId"].AsText().Trim();
        String GId = context.Request.Form["GId"].AsText().Trim();
        String MId = context.Request.Form["MId"].AsText().Trim();
        String MIdKey = context.Request.Form["MIdKey"].AsText().Trim();
        String ArsMId = context.Request.Form["ArsMId"].AsText().Trim();
        String ArsKey = context.Request.Form["ArsKey"].AsText().Trim();
        String LoanId = context.Request.Form["LoanId"].AsText().Trim();
        String LoanKey = context.Request.Form["LoanKey"].AsText().Trim();
        String Remark = context.Request.Form["Remark"].AsText().Trim();
        String MobileId = context.Request.Form["MobileId"].AsText().Trim();
        String MobileKey = context.Request.Form["MobileKey"].AsText().Trim();

        var paramList = new Dictionary<string, object>
        {
           {"nvar_P_COMPANY_CODE", CompCode},
           {"nvar_P_COMPANY_NO", CompNo},
           {"nvar_P_PG_AID", AId},
           {"nvar_P_PG_GID", GId},
           {"nvar_P_PG_MID", MId},
           {"nvar_P_PG_MIDKEY", MIdKey},
           {"nvar_P_PG_ARS_MID", ArsMId},
           {"nvar_P_PG_ARS_MIDKEY", ArsKey},
           {"nvar_P_PG_LOAN_MID", LoanId},
           {"nvar_P_PG_LOAN_MIDKEY", LoanKey},
           {"nvar_P_SVID_USER", SvidUser},
           {"nvar_P_DELFLAG","Y" },
           {"nvar_P_REMARK", Remark},
           {"nvar_P_PG_MOBILE_MID", MobileId},
           {"nvar_P_PG_MOBILE_MIDKEY", MobileKey}
        };

        GoodsService.SavePgUpdate(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("OK");
    }

    // PG 리스트 상세보기
    protected void GetPGCompDetail(HttpContext context)
    {
        String CompanyCode = context.Request.Form["CompanyCode"].AsText();

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_COMPANY_CODE", CompanyCode}
        };

        var list = OrderService.GetOrderPgInfo_Admin(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }

    // PG 등록 및 조회 관리 리스트 조회
    protected void GetPGRegisterCompList(HttpContext context)
    {
        String SearchTarget = context.Request.Form["SearchTarget"].AsText();
        String KeyWord = context.Request.Form["SearchKeyWord"].AsText();
        int PageNo = context.Request.Form["PageNo"].AsInt();
        int PageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_SEARCHKEYWORD", KeyWord},
            {"nvar_P_SERACHTARGET", SearchTarget},
            {"inte_P_PAGENO", PageNo },
            {"inte_P_PAGESIZE", PageSize },
        };

        var list = UserService.Get_PG_List_Admin(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);

    }

    // 회사코드 목록 조회
    protected void GetCompanyList(HttpContext context, string nextCode)
    {
        string companyNo = context.Request.Form["CompanyNo"]; // 사업자 번호

        var paramList = new Dictionary<string, object> {
           { "nvar_P_COMPNO", companyNo}
        };
        var list = CompanyService.GetCompanyListByCompNo(paramList);

        if ((list != null) && (list.Count > 0))
            list[0].NewCode = nextCode;

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }

    // 회사코드 목록 조회- 구분별
    protected void GetCompanyList_GubnCompNo(HttpContext context, string nextCode)
    {
        string companyNo = context.Request.Form["CompanyNo"].AsText(); // 사업자 번호
        string gubun = context.Request.Form["Gubun"].AsText(); //구분(A:판매사, B:구매사)

        var paramList = new Dictionary<string, object> {
           { "nvar_P_COMPNO", companyNo},
           { "nvar_P_GUBUN", gubun}
        };
        var list = CompanyService.GetCompanyListByGubunCompNo(paramList);

        if ((list != null) && (list.Count > 0))
            list[0].NewCode = nextCode;

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }

    #region << 회사코드 자동 생성 >>
    protected void CompanyCodeGenerate(HttpContext context)
    {
        var lastCode = CompanyService.GetLastCompanyCode();
        string nextCode = string.Empty;

        if (!string.IsNullOrWhiteSpace(lastCode))
        {
            nextCode = StringValue.GetNextCompanyCode(lastCode); //코드 자동생성
        }
        else
        {
            nextCode = "AA001"; //최초 회사 코드
        }

        CompanyInfoSave(context, nextCode); // DB 저장
    }
    #endregion

    #region << 데이터바인드 - 회사정보 저장 >>
    protected void CompanyInfoSave(HttpContext context, string nextCode)
    {
        string companyNo = context.Request.Form["CompanyNo"]; // 사업자 번호
        string compName = context.Request.Form["CompanyName"]; // 회사명
        string gubun = context.Request.Form["Gubun"]; // 구분 : B
        string remark = context.Request.Form["Remark"]; // 비고

        try
        {
            var paramList = new Dictionary<string, object>() {
                     {"nvar_P_COMPANY_CODE", nextCode}
                    ,{"nvar_P_COMPANY_NAME", compName}
                    ,{"nvar_P_COMPANY_NO", companyNo}
                    ,{"nvar_P_UNIQUE_NO", ""}
                    ,{"nvar_P_GUBUN", gubun}
                    ,{"nvar_P_REMARK", remark}
                    ,{"nvar_P_COMPANYAREA_CODE", ""}
                    ,{"nvar_P_COMPANYAREA_NAME", ""}
                    ,{"nvar_P_COMPBUSINESSDEPT_CODE", ""}
                    ,{"nvar_P_COMPBUSINESSDEPT_NAME", ""}
                    ,{"nvar_P_COMPANYDEPT_CODE", ""}
                    ,{"nvar_P_COMPANYDEPT_NAME", ""}
                    ,{"nvar_P_FLAG", "COMPANY"}
                };

            CompanyService.SaveCompanyInfo(paramList);

            //GetCompanyList(context, nextCode);
            GetCompanyList_GubnCompNo(context, nextCode);
        }
        catch (Exception ex)
        {
            if (IsErrorEnabled)
            {
                logger.Error(ex, "CompanyInfoSave Error");
            }
        }
    }
    #endregion

    // 회사명, 비고 수정
    public void CompanyNameUpdate(HttpContext context)
    {
        string compCode = context.Request.Form["CompanyCode"];
        string compName = context.Request.Form["CompanyName"];
        string compNo = context.Request.Form["CompanyNo"];
        string remark = context.Request.Form["Remark"];
        string gubun = context.Request.Form["Gubun"]; // 구분 : A/B

        try
        {
            var paramList = new Dictionary<string, object>()
            {
                {"nvar_P_COMPANY_CODE", compCode}
                ,{"nvar_P_COMPANY_NAME", compName}
                ,{"nvar_P_COMPANY_NO", compNo}
                ,{"nvar_P_COMPANYAREA_CODE", ""}
                ,{"nvar_P_COMPANYAREA_NAME", ""}
                ,{"nvar_P_COMPBUSINESSDEPT_CODE", ""}
                ,{"nvar_P_COMPBUSINESSDEPT_NAME", ""}
                ,{"nvar_P_COMPANYDEPT_CODE", ""}
                ,{"nvar_P_COMPANYDEPT_NAME", ""}
                ,{"nvar_P_REMARK", remark}
                ,{"nvar_P_FLAG", "COMPANY"}
            };

            CompanyService.UpdateCompanyInfo(paramList); // 디비 수정

            //GetCompanyList(context, "");
            GetCompanyList_GubnCompNo(context, "");

            //현재 에러났을 경우 로그에만 찍히는데 오류 리턴 받을 수 있게 문의..........................

        }
        catch (Exception ex)
        {
            if (logger.IsErrorEnabled)
            {
                logger.Error(ex, "ErrorMessage");
            }
        }
    }
    // 주문내역확인서 문서출력
    public void GetSaleCompanyDocumentInfo(HttpContext context)
    {
        string code = context.Request.Form["SaleCompCode"]; // 사업자 번호

        var paramList = new Dictionary<string, object> {
           { "nvar_P_SALECOMPANYCODE", code}
        };
        var list = CompanyService.GetSaleCompanyDocumentInfo(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    //[관리자]구매사 결제 유형 코드 관리
    protected void BorderTypeMgt(HttpContext context)
    {
        string code = context.Request.Form["Code"].AsText();
        string delFlag = context.Request.Form["DelFlag"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "char_P_TYPE", "A" },
            { "nvar_P_URIANBORDERTCODE", code },
            { "char_P_DELFLAG", delFlag },
            { "nvar_P_URIANBORDERTNAME", "" },
            { "nvar_P_REMARK", "" },
        };

        CompanyService.BorderTypeMgt(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    // 상품수정용 판매사 리스트
    public void GetSaleCompanyList(HttpContext context)
    {
        string keyword = context.Request.Form["Keyword"];  //판매사명 검색 키워드
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHKEYWORD", keyword},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},
        };
        var list = CompanyService.GetSaleCompanyList(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    // 상품수정용 공급사 리스트
    public void GetSupplyCompanyList(HttpContext context)
    {
        string target = context.Request.Form["Target"];
        string keyword = context.Request.Form["Keyword"];
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHTARGET", target},
            {"nvar_P_SEARCHKEYWORD", keyword},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},

        };
        var list = CompanyService.GetSupplyCompanyList(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    // 회사관리 리스트
    public void GetCompanyManagementList(HttpContext context)
    {
        string keyword = context.Request.Form["Keyword"];  // 검색 키워드
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();
        string target = context.Request.Form["Target"];
        string selectComp = context.Request.Form["SelectComp"];

        var paramList = new Dictionary<string, object> {
            {"nvar_P_GUBUN", selectComp},
            {"nvar_P_SEARCHTARGET", target},
            {"nvar_P_SEARCHKEYWORD", keyword},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},
        };
        var list = CompanyService.GetCompanyMngtList_Admin(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    //회사관리 리스트 카운트 조회
    public void GetCompanyManagementListCount(HttpContext context)
    {

        var paramList = new Dictionary<string, object>
        {
        };
        var list = CompanyService.GetCompanyMngtListCnt_Admin(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    //회사관리Info
    public void GetCompanyMngtInfo_Admin(HttpContext context)
    {
        string compCode = context.Request.Form["CompCode"];
        string compNo = context.Request.Form["CompNo"];
        string gubun = context.Request.Form["Gubun"];

        var paramList = new Dictionary<string, object> {
           { "nvar_P_COMPANY_CODE", compCode},
           { "nvar_P_COMPANY_NO", compNo},
           { "nvar_P_GUBUN", gubun}
        };
        var list = CompanyService.GetCompanyMngtInfo_Admin(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    //[관리자] 회사관리 정보 저장
    protected void SaveCompanyMngt_Admin(HttpContext context)
    {
        string compCode = context.Request.Form["CompCode"].AsText();
        string compNo = context.Request.Form["CompNo"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string compNm = context.Request.Form["CompNm"].AsText();
        string delFlag = context.Request.Form["DelFlag"].AsText();
        string BTypeRole = context.Request.Form["BTypeRole"].AsText();
        string ATypeRole = context.Request.Form["ATypeRole"].AsText();
        string BPayType = context.Request.Form["BPayType"].AsText();
        string billCheck = context.Request.Form["BillCheck"].AsText();
        string billUserNm = context.Request.Form["BillUserNm"].AsText();
        string billTel = context.Request.Form["BillTel"].AsText();
        string billFaX = context.Request.Form["BillFax"].AsText();
        string billEmail = context.Request.Form["BillEmail"].AsText();
        string uptae = context.Request.Form["Uptae"].AsText();
        string upjong = context.Request.Form["Upjong"].AsText();

        string compLoanYN = context.Request.Form["CompLoanYN"].AsText();
        decimal loanPrice = context.Request.Form["LoanPrice"].AsDecimal();
        decimal loanUsePrice = context.Request.Form["LoanUsePrice"].AsDecimal();
        decimal loanPayUsePrice = context.Request.Form["LoanPayUsePrice"].AsDecimal();
        string loanPayway = context.Request.Form["LoanPayway"].AsText();
        string assuranceYN = context.Request.Form["AssuranceYN"].AsText();
        string collateralYN = context.Request.Form["CollateralYN"].AsText();
        string loanPayDate = context.Request.Form["LoanPayDate"].AsText();
        string loanStartDate = context.Request.Form["LoanStartDate"].AsText();
        string loanEndDate = context.Request.Form["LoanEndDate"].AsText();
        decimal loanMonsPayPrice = context.Request.Form["LoanMonsPayPrice"].AsDecimal();
        string loanBillDate = context.Request.Form["LoanBillDate"].AsText();
        string loanCalDate = context.Request.Form["LoanCalDate"].AsText();
        string loanCalDue = context.Request.Form["LoanCalDue"].AsText();
        string loanPassYN = context.Request.Form["LoanPassYN"].AsText();
        string gdsLoanDelFlag = context.Request.Form["GdsLoanDelFlag"].AsText();

        string bloanyn = context.Request.Form["Bloanyn"].AsText();  //구매사 대금 결제 유무
        string groupSaleCompId = context.Request.Form["GroupSaleCompId"].AsText();//그룹 판매사 ID
        string startDate = context.Request.Form["StartDate"].AsText(); //계약시작일
        string endDate = context.Request.Form["EndDate"].AsText(); //계약종료일

        string BOrdType = context.Request.Form["BOrdType"].AsText(); //구매사 주문 유형
        string BDongShinCheck = context.Request.Form["SaleUrian"].AsText(); //자사체크
        string groupChk = context.Request.Form["GroupChk"].AsText(); //그룹 판매사 사용 여부
        string ATypeUrl = context.Request.Form["ATypeUrl"].AsText(); //판매사 플랫폼 URL
        string adminUserId = context.Request.Form["AdminUserId"].AsText(); //우리안 관리 담당자
        string delegateName = context.Request.Form["DelegateName"].AsText(); //대표자명
        string ABillType = context.Request.Form["ABillType"].AsText(); //(판매사)세금계산서 유형
        string BDsCode = context.Request.Form["BDsCode"].AsText(); //(구매사)자사체크코드
        string BTender = context.Request.Form["BTender"].AsText(); //(구매사)입찰유무
        string freeCompYN = context.Request.Form["FreeCompYN"].AsText(); //민간 업체 유무
        string freeCompVATYN = context.Request.Form["FreeCompVATYN"].AsText(); //민간 업체 부가세 포함 유무
        string remark = context.Request.Form["Remark"].AsText(); //비고
        string autoConfirmYn = context.Request.Form["AutoConfirmYn"].AsText(); //(구매사회원가입에 대한)자동승인유무

        int BOrderSelectWeek = context.Request.Form["BOrderSelectWeek"].AsInt(); //구매사 주문선택 주기
        string BPCompareYN = context.Request.Form["BPCompareYN"].AsText(); //가격비교사용유무
        string rmpsChkYN = context.Request.Form["RmpsChkYN"].AsText(); // 판매사 RMPS 유무

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_COMPANY_CODE", compCode },
            { "nvar_P_COMPANY_NO", compNo },
            { "nvar_P_GUBUN", gubun },
            { "nvar_P_COMPANY_NAME", compNm },
            { "nvar_P_DELFLAG", delFlag },
            { "nvar_P_UNIQUE_NO", "" },
            { "nvar_P_BTYPEROLE", BTypeRole },
            { "nvar_P_ATYPEROLE", ATypeRole },
            { "nvar_P_COMPLOANYN", compLoanYN },
            { "nvar_P_BPAYTYPE", BPayType },
            { "nvar_P_BILLCHECK", billCheck },
            { "nvar_P_BILLUSERNM", billUserNm },
            { "nvar_P_BILLTEL", billTel },
            { "nvar_P_BILLFAX", billFaX },
            { "nvar_P_BILLEMAIL", billEmail },
            { "nvar_P_UPTAE", uptae },
            { "nvar_P_UPJONG", upjong },
            { "nume_P_LOANPRICE", loanPrice },
            { "nume_P_LOANUSEPRICE", loanUsePrice },
            { "nume_P_LOANPAYUSEPRICE", loanPayUsePrice },
            { "nvar_P_LOANPAYWAY", loanPayway },
            { "nvar_P_ASSURANCEYN", assuranceYN },
            { "nvar_P_COLLATERALYN", collateralYN },
            { "nvar_P_GOODSLOAN_DELFLAG", gdsLoanDelFlag },
            { "nvar_P_LOANPAYDATE", loanPayDate },
            { "nvar_P_LOANSTARTDATE", loanStartDate },
            { "nvar_P_LOANENDDATE", loanEndDate },
            { "nvar_P_BLOANYN", bloanyn },
            { "nvar_P_GROUPCHECK", groupChk },
            { "nvar_P_GROUPCOMPANYID", groupSaleCompId },
            { "nvar_P_CPCONSTARTDATE", startDate },
            { "nvar_P_CPCONENDDATE", endDate },
            { "nvar_P_BORDERTYPE", BOrdType },
            { "nvar_P_BDONGSHINCHECK", BDongShinCheck },
            { "nvar_P_ATYPEURL", ATypeUrl },
            { "nvar_P_ADMINUSERID", adminUserId },
            { "nvar_P_DELEGATE_NAME", delegateName },
            { "nvar_P_ABILLTYPE", ABillType },
            { "nume_P_LOANMONSPAYPRICE", loanMonsPayPrice },
            { "nvar_P_LOANBILLDATE", loanBillDate },
            { "nvar_P_LOANCALDATE", loanCalDate },
            { "nvar_P_LOANCALDUE", loanCalDue },
            { "nvar_P_LOANPASSYN", loanPassYN },
            { "nvar_P_BTENDER", BTender },
            { "nvar_P_FREECOMPYN", freeCompYN },
            { "nvar_P_FREECOMPVATYN", freeCompVATYN },
            { "nvar_P_REMARK", remark },
            { "nvar_P_AUTOCONFIRMYN", autoConfirmYn },
            { "nume_P_BORDERSELECTWEEK", BOrderSelectWeek },
            { "nvar_P_BPESTIMATECOMPAREYN", BPCompareYN },
            { "nvar_P_RMPSCHECK", rmpsChkYN }
        };

        CompanyService.SaveCompanyMngt_Admin(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    //[selectbox용]구매사 결제유형 조회
    public void GetBTypeRoleList(HttpContext context)
    {
        var paramList = new Dictionary<string, object> { };
        var list = CompanyService.GetBTypeRoleList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    //공급사 수정용 리스트
    public void SupComUdateList(HttpContext context)
    {
        string SupplyCompanyCode = context.Request.Form["supplyCompanyCode"];
        string SupplyCompany_No = context.Request.Form["supplyCompany_No"];

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHTARGET", SupplyCompanyCode},
            {"nvar_P_SEARCHKEYWORD", SupplyCompany_No},
        };
        var list = CompanyService.GetSupplierUpdateList(paramList);



        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    //회사 여신 문서 조회
    public void GetGoodsLoanDocList(HttpContext context)
    {
        string compCode = context.Request.Form["CompCode"].AsText();
        string mapCode = context.Request.Form["MapCode"].AsText();
        int compChanel = context.Request.Form["CompChanel"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMPANY_CODE", compCode},
            {"nvar_P_MAP_CODE", mapCode},
            {"nume_P_COMM_CHANEL", compChanel}
        };
        var list = CompanyService.GetGoodsLoanDocList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }


    //사업자 등록번호 조회
    protected void CheckComNo(HttpContext context)
    {
        CompanyService CompanyService = new CompanyService();
        HttpContext.Current.Response.ContentType = "text/json";
        string ComCodeNo = context.Request.Form["CompanyCode"];
        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMCODENO", ComCodeNo}

        };

        var companyInfo = CompanyService.CheckCompanyCode(paramList);
        var returnjsonData = JsonConvert.SerializeObject(companyInfo);
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //[여신문서] 여신문서 삭제
    protected void DeleteGoodsLoanDoc(HttpContext context)
    {
        string svidLoanDoc = context.Request.Form["SvidLoanDoc"].AsText();
        string filePath = context.Request.Form["FilePath"].AsText();
        string fileName = context.Request.Form["FileName"].AsText();

        string uploadFolderServerPath = context.Server.MapPath(ConfigurationManager.AppSettings["UpLoadFolder"]); //컨피그에 설정된 Upload폴더 가져오기

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_SVID_GOODSLOANDOC", svidLoanDoc}
        };

        CompanyService.DeleteGoodsLoanDoc(paramList);

        var fullPath = uploadFolderServerPath + filePath + fileName;
        FileHelper.FileDelete(fullPath);

        string code = context.Request.Form["Code"].AsText();
        int channel = context.Request.Form["Channel"].AsInt();
        var paramList2 = new Dictionary<string, object>
        {
            { "nvar_P_MAPCODE", code},
            { "nume_P_MAPCHANEL", channel}
        };

        SocialWith.Biz.Comm.CommService commService = new SocialWith.Biz.Comm.CommService();

        var list = commService.GetCommList(paramList2);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    public void GetSocialCompLinkInfo(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"];

        var paramList = new Dictionary<string, object> {
           { "nvar_P_SVIDUSER", svidUser}
        };
        var list = CompanyService.GetSocialCompLinkInfo(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }
    
    //관계사 유저 판매사 갖고오기
    public void GetSocialCompUserLinkInfo(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"];

        var paramList = new Dictionary<string, object> {
           { "nvar_P_SVIDUSER", svidUser}
        };
        var list = CompanyService.GetSocialCompUserLinkInfo(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    public void GetGoodsPriceCompareSaleCompInfo(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"];
        string compCode = context.Request.Form["CompCode"];
        string groupNo = context.Request.Form["GroupNo"];
        string scompInfoNo = context.Request.Form["ScompInfoNo"];

        var paramList = new Dictionary<string, object> {
           { "nvar_P_SVIDUSER", svidUser},
           { "nvar_P_COMPANYCODE", compCode},
           { "nume_P_GROUPCOMPARENO", groupNo},
           { "nume_P_SCOMPINFONO", scompInfoNo},
        };
        var list = CompanyService.GetGoodsPriceCompareSaleCompInfo(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    //판매사 목록 조회
    public void GetCompanyList_A(HttpContext context)
    {
        string compNm = context.Request.Form["CompNm"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMPANY_NAME", compNm},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize}
        };

        var list = CompanyService.GetCompanyList_A(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    //주문 업체 저장
    public void SaveOrderSaleComp(HttpContext context)
    {
        string belongCode = context.Request.Form["BelongCode"].AsText();
        string areaCode = context.Request.Form["AreaCode"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        string saleCompNm = context.Request.Form["SaleCompNm"].AsText();
        string saleCompNo = context.Request.Form["SaleCompNo"].AsText();
        string uniqueNo = context.Request.Form["UniqueNo"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string remark = context.Request.Form["Remark"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_ORDERBELONG_CODE", belongCode},
            {"nvar_P_ORDERAREA_CODE", areaCode},
            {"nvar_P_ORDERSALECOMPANY_CODE", saleCompCode},
            {"nvar_P_ORDERSALECOMPANY_NAME", saleCompNm},
            {"nvar_P_COMPANY_NO", saleCompNo},
            {"nvar_P_UNIQUE_NO", uniqueNo},
            {"nvar_P_GUBUN", gubun},
            {"nvar_P_REMARK", remark},
            {"reVa_P_RETURN", 0}
        };

        var result = CompanyService.SaveOrderSaleCompReturn(paramList); //결과값
        var returnVal = string.Empty;

        if (result == 1)
        {
            returnVal = "OK"; // 저장 성공

        }
        else if (result == 2)
        {
            returnVal = "SAME"; //중복으로 저장 실패

        }
        else
        {
            returnVal = "ERR"; //오류로 저장 실패
        }

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnVal);
    }


    //그룹판매사 리스트
    public void GetGroupSaleCompList(HttpContext context)
    {
        string keyword = context.Request.Form["Keyword"];
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMPANY_NAME", keyword},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},

        };
        var list = CompanyService.GetGroupCompanyList_A(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }


    public void GetCompPriceCompanyList(HttpContext context)
    {
        string keyword = context.Request.Form["SearchKeyword"];
        string gubun = context.Request.Form["Gubun"];
        string saleSearchType = context.Request.Form["SaleSearchType"];
        string buySearchType = context.Request.Form["BuySearchType"];
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_GUBUN", gubun},
            {"nvar_P_SEARCHKEYWORD", keyword},
            {"nvar_P_SALESEARCHTYPE", saleSearchType},
            {"nvar_P_BUYSEARCHTYPE", buySearchType},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},
        };
        var list = CompanyService.GetCompPriceCompanyList(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    public void GetCompDisplayCompanyList(HttpContext context)
    {
        string keyword = context.Request.Form["SearchKeyword"];
        string gubun = context.Request.Form["Gubun"];
        string saleSearchType = context.Request.Form["SaleSearchType"];
        string buySearchType = context.Request.Form["BuySearchType"];
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_GUBUN", gubun},
            {"nvar_P_SEARCHKEYWORD", keyword},
            {"nvar_P_SALESEARCHTYPE", saleSearchType},
            {"nvar_P_BUYSEARCHTYPE", buySearchType},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},
        };
        var list = CompanyService.GetCompDisplayCompanyList(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    //[판매사 회원가입시]사업자번호로 가입된 회사가 존재하는지 체크
    public void GetTypeACompCountByCompNo(HttpContext context)
    {
        string compno = context.Request.Form["CompNo"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMPNO", compno},

        };
        var returnVal = CompanyService.GetTypeACompCountByCompNo(paramList);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnVal);
    }

    //[구매사 회원가입시]접속 Url과 사업자번호로 가입된 회사가 존재하는지 체크
    public void GetCompCountByCompNoUrl(HttpContext context)
    {
        string compno = context.Request.Form["CompNo"].AsText();
        string sitename = context.Request.Form["SiteName"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMPNO", compno},
            {"nvar_P_SITENAME", sitename},

        };
        var returnVal = CompanyService.GetCompCountByCompNoUrl(paramList);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnVal);
    }

    //회사 목록 조회(회사 코드, 명, 구분)
    public void GetCompanyListByGubun(HttpContext context)
    {
        string keyword = context.Request.Form["Keyword"].AsText();
        string target = context.Request.Form["Target"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHKEYWORD", keyword},
            {"nvar_P_SERACHTARGET", target },
            {"nvar_P_GUBUN", gubun },
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize}
        };

        var list = CompanyService.GetCompanyListByGubun(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    //관리자 아이디로 회사 목록 조회(회사 코드, 명, 구분)
    public void GetCompanyListByAdminId(HttpContext context)
    {
        string keyword = context.Request.Form["Keyword"].AsText();
        string target = context.Request.Form["Target"].AsText();
        string adminId = context.Request.Form["AdminId"].AsText();
        string loanYN = context.Request.Form["LoanYN"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SERACHTARGET", target },
            {"nvar_P_SEARCHKEYWORD", keyword},
            {"nvar_P_ADMINUSERID", adminId },
            {"nvar_P_BLOANYN", loanYN },
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize}
        };

        var list = CompanyService.GetCompanyListByAdminId(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    //회사검색
    public void GetCompanySearchList(HttpContext context)
    {
        string gubun = context.Request.Form["Gubun"].AsText();
        string keyword = context.Request.Form["Keyword"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_GUBUN", gubun },
            {"nvar_P_SEARCHKEYWORD", keyword},
            {"inte_P_PAGENO", pageNo },
            {"inte_P_PAGESIZE", pageSize },
        };

        var list = CompanyService.GetCompanySearchList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    //사업자번호없음코드 생성
    public void GetLastNoneComNoCode(HttpContext context)
    {
        string companyCode = context.Request.Form["ComCode"].AsText(); //회사코드

        string result = string.Empty;
        string newCode = string.Empty;
        string basicFomat = "CX00000000";

        var lastCode = CompanyService.GetLastNoneComNoCode();

        if (string.IsNullOrEmpty(lastCode))
        {
            result = "FAIL";
        }
        else
        {
            result = "SUCCESS";

            //조회한 코드를 이용해서 새 코드 생성해야 함.
            string strNum = lastCode.Substring(2);

            int oldNum = strNum.AsInt();

            if (oldNum == 999999999)
            {
                result = "OVER";

            }
            else
            {
                int newNum = ++oldNum;
                string newStrNum = newNum.AsText();
                newCode = basicFomat.Substring(0, (basicFomat.Length - newStrNum.Length)) + newStrNum;

                string noneComNo = string.Empty;
                noneComNo = newCode.Substring(0, 3) + "-" + newCode.Substring(3, 2) + "-" + newCode.Substring(5);

                //사업자번호없음 코드로 변경
                var paramList = new Dictionary<string, object> {
                    {"nvar_P_COMPANYCODE", companyCode},
                    {"nvar_P_NONECOMNOCODE", noneComNo},
                    {"nvar_P_REMARK", newCode}
                };

                CompanyService.UpdateNoneComNo(paramList); //사업자번호 변경
            }
        }

        var resultList = new Dictionary<string, object> {
            {"result", result},
            {"newCode", newCode}
        };

        var returnJsonData = JsonConvert.SerializeObject(resultList);
        context.Response.ContentType = "text/json";
        context.Response.Write(returnJsonData);
    }

    //RMP가격등록 
    public void InsertRmpCompPrice(HttpContext context)
    {
        string company_Code = context.Request.Form["company_Code"].AsText(); //회사코드
        string startDate = context.Request.Form["startDate"].AsText(); //시작일
        string endDate = context.Request.Form["endDate"].AsText(); //종료일
        int SWPPriceP = context.Request.Form["SWPPriceP"].AsInt(); //소셜위드기준
        int RMPPriceP1 = context.Request.Form["RMPPriceP1"].AsInt(); //RMP기준
        int RMPPriceP2 = context.Request.Form["RMPPriceP2"].AsInt();
        int saleCompPriceP = context.Request.Form["saleCompPriceP"].AsInt();


        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMPANYCODE", company_Code},
            {"nvar_P_TODATEB", startDate},
            {"nvar_P_TODATEE", endDate},
            {"inte_P_SWPPRICEP", SWPPriceP},
            {"inte_P_RMPPRICEP1", RMPPriceP1},
            {"inte_P_RMPPRICEP2", RMPPriceP2},
            {"inte_P_SALECOMPPRICEP", saleCompPriceP},
        };

        CompanyService.InsertRmpCompPrice(paramList);
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    public void GetRmpCompPriceList(HttpContext context)
    {
        string target = context.Request.Form["Target"].AsText();
        string keyword = context.Request.Form["Keyword"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_SERACHTARGET", target},
            {"nvar_P_SEARCHKEYWORD", keyword},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize}
        };


        var list = CompanyService.GetRmpCompPriceList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);
        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    //사용유무
    public void UpdateRmpCompPrice(HttpContext context)
    {
        string Unum_RmpCompanyPrice = context.Request.Form["Unum_RmpCompanyPrice"].AsText();
        string Delflag = context.Request.Form["Delflag"].AsText();



        var paramList = new Dictionary<string, object> {
            {"nvar_P_UNUM_RMPCOMPANYPRICE", Unum_RmpCompanyPrice},
            {"nvar_P_DELFLAG", Delflag}

        };

        CompanyService.UpdateRmpCompPrice(paramList);
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    //주문연동관리 주문업체조회(관리자)
    protected void GetOrderSaleCompPopup_Admin(HttpContext context)
    {
        string orderBelong_Code = context.Request.Form["OrderBelong_Code"].AsText();
        string orderArea_Code = context.Request.Form["OrderArea_Code"].AsText();
        string orderSaleCompany_Code = context.Request.Form["OrderSaleCompany_Code"].AsText();


        var paramList = new Dictionary<string, object> {
            {"nvar_P_ORDERBELONG_CODE", orderBelong_Code},
            {"nvar_P_ORDERAREA_CODE", orderArea_Code},
            {"nvar_P_ORDERSALECOMPANY_CODE", orderSaleCompany_Code},

        };

        var list = CompanyService.GetOrderSaleComInfo_Admin(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //주문관리 - 정산내역조회 - 최종현황 - 회사조회 (관리자)
    protected void GetSearchCompanyList(HttpContext context)
    {

        string searchKeyword = context.Request.Form["SearchKeyword"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHKEYWORD", searchKeyword},
            {"nvar_P_GUBUN", gubun},
            {"nvar_P_PAGENO", pageNo},
            {"nvar_P_PAGESIZE", pageSize},

        };

        var list = CompanyService.GetSearchCompanyList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);


    }

    // 판매사 정산내역조회
    protected void GetSalesExactcal(HttpContext context)
    {
        string Month = context.Request.Form["Month"].AsText();
        string Gubun = context.Request.Form["Gubun"].AsText();
        string CompCode = context.Request.Form["CompCode"].AsText();
        string BuyerCompany_Name = context.Request.Form["BuyerCompany_Name"].AsText();
        string PayWay = context.Request.Form["PayWay"].AsText();
        int PageNo = context.Request.Form["PageNo"].AsInt();
        int PageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_MONTH", Month },
            {"nvar_P_GUBUN", Gubun },
            {"nvar_P_COMPCODE", CompCode },
            {"nvar_P_BUYERCOMPANY_NAME", BuyerCompany_Name },
            {"nvar_P_PAYWAY", PayWay },
            {"inte_P_PAGENO", PageNo },
            {"inte_P_PAGESIZE", PageSize }
        };

        var list = PayService.GetSalesExactcal(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}