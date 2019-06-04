using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Urian.Core;
using NLog;
using System.Text;
/// <summary>
/// StringValue의 요약 설명입니다.
/// </summary>
public class StringValue
{
    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    public static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    public static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    public static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    public static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    public static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    public static string[] strApbtArr = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };
    #endregion
    public StringValue()
    {
        //
        // TODO: 여기에 생성자 논리를 추가합니다.
        //
    }
    
    public static string GetRandomPassword(int length)
    {
        var rand = new Random();
        string input = "abcdefghijklmnopqrstuvwxyz0123456789";
        var chars = Enumerable.Range(0, length).Select(x => input[rand.Next(0, input.Length)]);
        return new string(chars.ToArray());
    }


    //부서코드 생성
    public static string GetNextCompDeptCode(string curCode) {

        string createCode = string.Empty;
        string charApbt = curCode.Substring(0, 2); // 첫 영문자
        string strNum = curCode.Substring(2, 3); // 나머지 4자리 숫자
        int intNumVal = strNum.AsInt(); // 문자형식으로 가져온 4자리 숫자를 int 형으로 변환

        intNumVal = ++intNumVal; //숫자증가
        createCode = charApbt + intNumVal.ToString("000"); // 최종적으로 생성된 코드 저장

        return createCode;
    }


    //회사 구분코드 생성
    public static string GetNextSocialGubunCode(string gubun, string curCode)
    {
        string createCode = string.Empty;
        if (string.IsNullOrWhiteSpace(curCode))
        {
            createCode = gubun +  "0001";
            return createCode;

        }
        
        string fixApbt = gubun; // 첫 영문자
        string fixChar = curCode.Substring(2, 4); // 9999 or A999
        string divChar = fixChar.Substring(0, 1); // 9 or A
        string divNum = fixChar.Substring(1, 3); //000

        string resultCode = "0001";
        
        int divNumParseInt = divNum.AsInt();

        int i = 0;
        string disitString = string.Empty;
        bool isNum = int.TryParse(divChar, out i); //세번째 자리가 숫자 true/문자 false 여부 체크 


        if (isNum)
        {
            if (fixChar.AsInt() != 9999)
            {
                int fixCharParseInt = fixChar.AsInt();
                fixCharParseInt = ++fixCharParseInt;
                resultCode = fixCharParseInt.ToString("0000");
            }
            else
            {
                resultCode = "A001";
            }
        }
        else
        {
            if (divNumParseInt < 999)
            {
                divNumParseInt = ++divNumParseInt;
                resultCode = divChar + divNumParseInt.ToString("000");
            }
            else
            {
                int indexApbt = Array.IndexOf(strApbtArr, divChar.ToUpper()); // 최종적으로 코드의 일부가 될 영문자 배열 번호값 저장 - string[] strApbtArr 변수에서 사용
                indexApbt++;

                if (indexApbt == strApbtArr.Length)
                {
                    indexApbt = 0;
                }
                resultCode = strApbtArr[indexApbt].ToString() + "001";

            }
        }

        createCode = fixApbt + resultCode; // 최종적으로 생성된 코드 저장
        return createCode;

    }


    //상품 그룹코드 생성
    public static string GetNextGoodsGroupCode(string curCode)
    {
        string createCode = string.Empty;
        if (string.IsNullOrWhiteSpace(curCode))
        {
            createCode = "GP00001";
            return createCode;

        }

        string fixApbt = curCode.Substring(0, 2); ; // 첫 영문자
        string fixChar = curCode.Substring(2, 5); // 99999 or A9999
        string divChar = fixChar.Substring(0, 1); // fixChar 앞자리 9 or A
        string divNum = fixChar.Substring(1, 4); //fixChar 앞자리 제외한 나머지 숫자 0000 

        string resultCode = "00001";
        
        int divNumParseInt = divNum.AsInt();

        int i = 0;
        string disitString = string.Empty;
        bool isNum = int.TryParse(divChar, out i); //세번째 자리가 숫자 true/문자 false 여부 체크 


        if (isNum)
        {
            if (fixChar.AsInt() != 99999)
            {
                int fixCharParseInt = fixChar.AsInt();
                fixCharParseInt = ++fixCharParseInt;
                resultCode = fixCharParseInt.ToString("00000");
            }
            else
            {
                resultCode = "A0001";
            }
        }
        else
        {
            if (divNumParseInt < 999)
            {
                divNumParseInt = ++divNumParseInt;
                resultCode = divChar + divNumParseInt.ToString("0000");
            }
            else
            {
                int indexApbt = Array.IndexOf(strApbtArr, divChar.ToUpper()); // 최종적으로 코드의 일부가 될 영문자 배열 번호값 저장 - string[] strApbtArr 변수에서 사용
                indexApbt++;

                if (indexApbt == strApbtArr.Length)
                {
                    indexApbt = 0;
                }
                resultCode = strApbtArr[indexApbt].ToString() + "0001";

            }
        }

        createCode = fixApbt + resultCode; // 최종적으로 생성된 코드 저장
        return createCode;
    }

    //서비스용역등록 그룹코드 생성
    public static string GetNextGoodsServiceGroupCode(string curCode)
    {
        string createCode = string.Empty;
        if (string.IsNullOrWhiteSpace(curCode))
        {
            createCode = "GV00001";
            return createCode;

        }

        string fixApbt = curCode.Substring(0, 2); ; // 첫 영문자
        string fixChar = curCode.Substring(2, 5); // 99999 or A9999
        string divChar = fixChar.Substring(0, 1); // fixChar 앞자리 9 or A
        string divNum = fixChar.Substring(1, 4); //fixChar 앞자리 제외한 나머지 숫자 0000 

        string resultCode = "00001";

        int divNumParseInt = divNum.AsInt();

        int i = 0;
        string disitString = string.Empty;
        bool isNum = int.TryParse(divChar, out i); //세번째 자리가 숫자 true/문자 false 여부 체크 


        if (isNum)
        {
            if (fixChar.AsInt() != 99999)
            {
                int fixCharParseInt = fixChar.AsInt();
                fixCharParseInt = ++fixCharParseInt;
                resultCode = fixCharParseInt.ToString("00000");
            }
            else
            {
                resultCode = "A0001";
            }
        }
        else
        {
            if (divNumParseInt < 999)
            {
                divNumParseInt = ++divNumParseInt;
                resultCode = divChar + divNumParseInt.ToString("0000");
            }
            else
            {
                int indexApbt = Array.IndexOf(strApbtArr, divChar.ToUpper()); // 최종적으로 코드의 일부가 될 영문자 배열 번호값 저장 - string[] strApbtArr 변수에서 사용
                indexApbt++;

                if (indexApbt == strApbtArr.Length)
                {
                    indexApbt = 0;
                }
                resultCode = strApbtArr[indexApbt].ToString() + "0001";

            }
        }

        createCode = fixApbt + resultCode; // 최종적으로 생성된 코드 저장
        return createCode;
    }

    //상품코드 생성
    public static string GetNextGoodsCode(string curCode)
    {
        //curCode = "SB115714";
        string createCode = string.Empty;
        if (string.IsNullOrWhiteSpace(curCode))
        {
            createCode = "SA000011";
            return createCode;

        }

        string fixApbt = curCode.Substring(0, 1);  // 고정 영문자
        string flexApbt = curCode.Substring(1, 1); //변경 영문자 
        string flexNum = curCode.Substring(2, 5); // 99999
        string resultCode = "000001";
        
        if (flexNum.AsInt() != 99999)
        {
            int flexNumParseInt = flexNum.AsInt();
            string nextFlexNum = (++flexNumParseInt).ToString("00000");
            string digit = GetGoodsCodeLastDigit(nextFlexNum , flexApbt.ToCharArray()[0]);
            resultCode = nextFlexNum + digit;
        }
        else
        {
            int indexApbt = Array.IndexOf(strApbtArr, flexApbt.ToUpper()); // 최종적으로 코드의 일부가 될 영문자 배열 번호값 저장 - string[] strApbtArr 변수에서 사용
            indexApbt++;

            if (indexApbt == strApbtArr.Length)
            {
                indexApbt = 0;
            }

            flexApbt = strApbtArr[indexApbt].ToString();
            flexNum = "00001";
            string digit = GetGoodsCodeLastDigit(flexNum, flexApbt.ToCharArray()[0]);
            resultCode = flexNum + digit;
        }
        
        createCode = fixApbt + flexApbt + resultCode; // 최종적으로 생성된 코드 저장
        return createCode;
    }


    //서비스 용역 등록 상품코드 생성
    public static string GetNextServiceGoodsCode(string curCode)
    {
        //curCode = "SB115714";
        string createCode = string.Empty;
        if (string.IsNullOrWhiteSpace(curCode))
        {
            createCode = "VA000011";
            return createCode;

        }

        string fixApbt = curCode.Substring(0, 1);  // 고정 영문자
        string flexApbt = curCode.Substring(1, 1); //변경 영문자 
        string flexNum = curCode.Substring(2, 5); // 99999
        string resultCode = "000001";

        if (flexNum.AsInt() != 99999)
        {
            int flexNumParseInt = flexNum.AsInt();
            string nextFlexNum = (++flexNumParseInt).ToString("00000");
            string digit = GetGoodsCodeLastDigit(nextFlexNum, flexApbt.ToCharArray()[0]);
            resultCode = nextFlexNum + digit;
        }
        else
        {
            int indexApbt = Array.IndexOf(strApbtArr, flexApbt.ToUpper()); // 최종적으로 코드의 일부가 될 영문자 배열 번호값 저장 - string[] strApbtArr 변수에서 사용
            indexApbt++;

            if (indexApbt == strApbtArr.Length)
            {
                indexApbt = 0;
            }

            flexApbt = strApbtArr[indexApbt].ToString();
            flexNum = "00001";
            string digit = GetGoodsCodeLastDigit(flexNum, flexApbt.ToCharArray()[0]);
            resultCode = flexNum + digit;
        }

        createCode = fixApbt + flexApbt + resultCode; // 최종적으로 생성된 코드 저장
        return createCode;
    }



    //상품코드 마지막 자리수 계산
    protected static string GetGoodsCodeLastDigit(string goodsCodeNum, char alphabet) {


        string returnVal = string.Empty;

        int digitNum1 = goodsCodeNum.Substring(0, 1).AsInt() * 1;
        int digitNum2 = goodsCodeNum.Substring(1, 1).AsInt() * 2;
        int digitNum3 = goodsCodeNum.Substring(2, 1).AsInt() * 1;
        int digitNum4 = goodsCodeNum.Substring(3, 1).AsInt() * 2;
        int digitNum5 = goodsCodeNum.Substring(4, 1).AsInt() * 1;
        int changeAsciiCode = Convert.ToInt32(alphabet) - 65;
        int digitTotal = digitNum1 + digitNum2 + digitNum3 + digitNum4 + digitNum5 + changeAsciiCode;
        returnVal = (digitTotal % 10).AsText();

        return returnVal;
    }

    // 회사코드 자동생성 기능(형식: 예제: CC000001)
    public static string GetNextCompanyCode(string curCode)
    {
        string createCode = string.Empty; // 최종 생성된 코드(리턴값)

        if (string.IsNullOrWhiteSpace(curCode))
        {
            createCode = "CC000001";
            return createCode;
        }

        string fixApbt = curCode.Substring(0, 2);  // 고정 영문자
        string flexChar = curCode.Substring(2, 6);  //유동 코드

        string flexCharFirst = flexChar.Substring(0, 1); // 0 ~ 9 or A ~ Z
        string flexCharRest = flexChar.Substring(1, 5); //00000

        string resultCode = "000001";

        int i = 0;
        bool isNum = int.TryParse(flexCharFirst, out i); //유동 코드 첫자리가 숫자 true/문자 false 여부 체크 

        if (isNum)  //유동 코드 첫자리가 숫자일경우
        {
            if (flexChar.AsInt() != 999999)   //유동코드가 마지막 숫자까지 채워지지 않았을경우
            {
                int fixCharParseInt = flexChar.AsInt();  
                fixCharParseInt = ++fixCharParseInt; // 유동코드를 +1 시킨다
                resultCode = fixCharParseInt.ToString("000000");
            }
            else   //유동코드가 마지막 숫자까지 채워졌을경우에 유동코드 첫자리를 A로 치환하고 뒤의 숫자코드를 초기화..
            {
                resultCode = "CCA00001";
            }
        }
        else //유동 코드 첫자리가 문자일경우
        {
            int flextCharRestInt = flexCharRest.AsInt();  //유동코드 첫자리를 뺀 나머지 숫자를 숫자형으로 형변환
            if (flexCharRest.AsInt() < 99999) //유동코드 첫자리를 뺀 나머지 숫자가 마지막 숫자까지 채워지지 않았을경우
            {
                flextCharRestInt = ++flextCharRestInt; //유동코드 첫자리를 뺀 나머지 숫자를 +1시킨다
                resultCode = flexCharFirst + flextCharRestInt.ToString("00000");
            }
            else //유동코드 첫자리를 뺀 나머지 숫자가 마지막 숫자까지 채워졌을 경우
            {
                int indexApbt = Array.IndexOf(strApbtArr, flexCharFirst.ToUpper()); // 최종적으로 코드의 일부가 될 영문자 배열 번호값 저장 - string[] strApbtArr 변수에서 사용
                indexApbt++; 

                if (indexApbt == strApbtArr.Length)
                {
                    indexApbt = 0;
                }
                resultCode = strApbtArr[indexApbt].ToString() + "00001";

            }
        }
        
        createCode = fixApbt + resultCode; // 최종적으로 생성된 코드 저장
        return createCode;
    }


    //사업장 코드 생성
    public static string NextAreaCode(string curCode)
    {
        string createCode = null; // 최종 생성된 코드(리턴값)

        string strNum = curCode; // 2자리 숫자

        int intNumVal = strNum.AsInt(); // 문자형식으로 가져온 3자리 숫자를 int 형으로 변환
        
        // 숫자 코드값이 999 보다 작은 경우
        if (intNumVal < 99)
        {
            ++intNumVal;
        }

        string resultNum = intNumVal.ToString("00"); // 숫자값을 3자리 숫자의 문자형으로 변환
        createCode = resultNum; // 최종적으로 생성된 회사명 코드 저장

        return createCode;
    }

    // 사업부 코드 자동 생성 기능(형식: 예제: CB001)
    public static string GetCompBusinessDeptCode(string curCode)
    {
        /*
        string createCode = null; // 최종 생성된 코드(리턴값)

        string charApbt = curCode.Substring(0, 2); // 첫 영문자
        string strNum = curCode.Substring(2, 3); // 나머지 3자리 숫자

        int intNumVal = strNum.AsInt(); // 문자형식으로 가져온 3자리 숫자를 int 형으로 변환

        // 알파벳 26자

        string resultApbt = charApbt; // 최종 첫 영문자가 저장될 변수

        int indexApbt = Array.IndexOf(strApbtArr, charApbt.ToUpper()); // 최종적으로 코드의 일부가 될 영문자 배열 번호값 저장 - string[] strApbtArr 변수에서 사용

        // 숫자 코드값이 999 보다 작은 경우
        if (intNumVal < 999)
        {
            ++intNumVal;
        }
        // 숫자 코드값이 999 보다 큰 경우
        else if (intNumVal == 999)
        {
            intNumVal = 1; // 다시 초기화

            ++indexApbt; // 다음 영문자의 배열 인덱스 번호로 증가

            // Z999 코드를 넘어서는 경우 다시 A001 로 초기화
            if (indexApbt == strApbtArr.Length)
            {
                indexApbt = 0;
            }
        }

        resultApbt = strApbtArr[indexApbt].ToString(); // 최종 영문자 저장
        string resultNum = intNumVal.ToString("000"); // 숫자값을 3자리 숫자의 문자형으로 변환

        createCode = resultApbt + resultNum; // 최종적으로 생성된 사업부 코드 저장

        return createCode;
        */


        string createCode = string.Empty;
        string charApbt = curCode.Substring(0, 2); // 첫 영문자
        string strNum = curCode.Substring(2, 3); // 나머지 4자리 숫자
        int intNumVal = strNum.AsInt(); // 문자형식으로 가져온 4자리 숫자를 int 형으로 변환

        intNumVal = ++intNumVal; //숫자증가
        createCode = charApbt + intNumVal.ToString("000"); // 최종적으로 생성된 코드 저장

        return createCode;
    }


    // 회사구분별 연동 코드 자동 생성 기능(형식: 예제: SCLK00000001)
    public static string NextLinkCode(string curCode)
    {
        string createCode = string.Empty;
        if (string.IsNullOrWhiteSpace(curCode))
        {
            createCode = "SCLK00000001";
            return createCode;

        }



        string fixApbt = curCode.Substring(0, 4);  // 고정 영문자
        string flexChar = curCode.Substring(4, 8);  //유동 코드

        string flexCharFirst = flexChar.Substring(0, 1); // 0 ~ 9 or A ~ Z
        string flexCharRest = flexChar.Substring(1, 7); //0000000

        string resultCode = "00000001";

        int i = 0;
        bool isNum = int.TryParse(flexCharFirst, out i); //유동 코드 첫자리가 숫자 true/문자 false 여부 체크

        if (isNum)  //유동 코드 첫자리가 숫자일경우
        {
            if (flexChar.AsInt() != 99999999)   //유동코드가 마지막 숫자까지 채워지지 않았을경우
            {
                int fixCharParseInt = flexChar.AsInt();
                fixCharParseInt = ++fixCharParseInt; // 유동코드를 +1 시킨다
                resultCode = fixCharParseInt.ToString("00000000");
            }
            else   //유동코드가 마지막 숫자까지 채워졌을경우에 유동코드 첫자리를 A로 치환하고 뒤의 숫자코드를 초기화..
            {
                resultCode = "A0000001";
            }
        }
        else //유동 코드 첫자리가 문자일경우
        {
            int flextCharRestInt = flexCharRest.AsInt();  //유동코드 첫자리를 뺀 나머지 숫자를 숫자형으로 형변환
            if (flexCharRest.AsInt() < 9999999) //유동코드 첫자리를 뺀 나머지 숫자가 마지막 숫자까지 채워지지 않았을경우
            {
                flextCharRestInt = ++flextCharRestInt; //유동코드 첫자리를 뺀 나머지 숫자를 +1시킨다
                resultCode = flexCharFirst + flextCharRestInt.ToString("0000000");
            }
            else //유동코드 첫자리를 뺀 나머지 숫자가 마지막 숫자까지 채워졌을 경우
            {
                int indexApbt = Array.IndexOf(strApbtArr, flexCharFirst.ToUpper()); // 최종적으로 코드의 일부가 될 영문자 배열 번호값 저장 - string[] strApbtArr 변수에서 사용
                indexApbt++;

                if (indexApbt == strApbtArr.Length)
                {
                    indexApbt = 0;
                }
                resultCode = strApbtArr[indexApbt].ToString() + "0000001";

            }
        }

        createCode = fixApbt + resultCode; // 최종적으로 생성된 코드 저장
        return createCode;

    }

    // 브랜드 코드 자동 생성 기능(형식: 예제: BC00001)
    public static string NextBrandCode(string curCode)
    {
        string createCode = string.Empty;
        if (string.IsNullOrWhiteSpace(curCode))
        {
            createCode = "BC00001";
            return createCode;

        }



        string fixApbt = curCode.Substring(0, 2);  // 고정 영문자
        string flexChar = curCode.Substring(2, 5);  //유동 코드

        string flexCharFirst = flexChar.Substring(0, 1); // 0 ~ 9 or A ~ Z
        string flexCharRest = flexChar.Substring(1, 4); //0000

        string resultCode = "00001";

        int i = 0;
        bool isNum = int.TryParse(flexCharFirst, out i); //유동 코드 첫자리가 숫자 true/문자 false 여부 체크

        if (isNum)  //유동 코드 첫자리가 숫자일경우
        {
            if (flexChar.AsInt() != 99999)   //유동코드가 마지막 숫자까지 채워지지 않았을경우
            {
                int fixCharParseInt = flexChar.AsInt();
                fixCharParseInt = ++fixCharParseInt; // 유동코드를 +1 시킨다
                resultCode = fixCharParseInt.ToString("00000");
            }
            else   //유동코드가 마지막 숫자까지 채워졌을경우에 유동코드 첫자리를 A로 치환하고 뒤의 숫자코드를 초기화..
            {
                resultCode = "A0001";
            }
        }
        else //유동 코드 첫자리가 문자일경우
        {
            int flextCharRestInt = flexCharRest.AsInt();  //유동코드 첫자리를 뺀 나머지 숫자를 숫자형으로 형변환
            if (flexCharRest.AsInt() < 9999) //유동코드 첫자리를 뺀 나머지 숫자가 마지막 숫자까지 채워지지 않았을경우
            {
                flextCharRestInt = ++flextCharRestInt; //유동코드 첫자리를 뺀 나머지 숫자를 +1시킨다
                resultCode = flexCharFirst + flextCharRestInt.ToString("0000");
            }
            else //유동코드 첫자리를 뺀 나머지 숫자가 마지막 숫자까지 채워졌을 경우
            {
                int indexApbt = Array.IndexOf(strApbtArr, flexCharFirst.ToUpper()); // 최종적으로 코드의 일부가 될 영문자 배열 번호값 저장 - string[] strApbtArr 변수에서 사용
                indexApbt++;

                if (indexApbt == strApbtArr.Length)
                {
                    indexApbt = 0;
                }
                resultCode = strApbtArr[indexApbt].ToString() + "00001";

            }
        }

        createCode = fixApbt + resultCode; // 최종적으로 생성된 코드 저장
        return createCode;

    }

    //사이트 배포 코드 관리
    public static string NextDistCssCode(string curCode)
    {
        string createCode = string.Empty;

        if (string.IsNullOrWhiteSpace(curCode))
        {
            createCode = "DS00000001";
        }
        else
        {
            int intNumVal = curCode.Substring(2).AsInt();

            if (intNumVal < 99999999)
            {
                intNumVal++;
            }
            else
            {

            }
            createCode = "DS" + intNumVal.ToString("00000000"); ;
        }
        
        return createCode;
    }
    
    public static string NextCartCode()
    {
        SocialWith.Biz.Cart.CartService cartService = new SocialWith.Biz.Cart.CartService();
        string nextSeq = cartService.GetLastCartCode();
        string nowDate = DateTime.Now.ToString("yyMMdd");

        string nextCode = "CN-" + nowDate + "-" + nextSeq;
        return nextCode;
    }

    public static string NextOrderCodeNo()
    {
        SocialWith.Biz.Order.OrderService OrderService = new SocialWith.Biz.Order.OrderService();
        string nextSeq = OrderService.GetNextOrderCodeNo();
        string nowDate = DateTime.Now.ToString("yyMMdd");

        string nextCode = "ON-" + nowDate + "-" + nextSeq;

        return nextCode;
    }

    public static string NextSystemUpdateCode()
    {
        SocialWith.Biz.SystemUpdate.SystemUpdateService sysService = new SocialWith.Biz.SystemUpdate.SystemUpdateService();
        string nextSeq = sysService.GetLastSysUpdateCode();
        string nowDate = DateTime.Now.ToString("yyMMdd");

        string nextCode = "SRN-" + nowDate + "-" + nextSeq;
        return nextCode;
    }


    //신규견적요청 코드 생성
    public static string NextNewGoodCode()
    {
        SocialWith.Biz.Goods.GoodsService goodsService = new SocialWith.Biz.Goods.GoodsService();
        int nextSeq = goodsService.GetLastNewGoodSeq();
        string nowDate = DateTime.Now.ToString("yyMMdd");

        string nextCode = "GRQN-" + nowDate + "-" + nextSeq;
        return nextCode;
    }


    //프로모션 코드 생성
    public static string NextPromotionRoleCode(string curCode,  string type)
    {
        string returnVal = string.Empty;

        if (string.IsNullOrWhiteSpace(curCode))
        {
            if (type == "Promotion")
            {
                returnVal = "PMD" + DateTime.Now.ToString("yy") + "000001";
            }
            else if (type == "Role")
            {
                returnVal = "GA" + DateTime.Now.ToString("yy") + "000001";
            }
        }
        else
        {
            int num = curCode.Substring(5, 6).AsInt() + 1;
            if (type == "Promotion")
            {
                returnVal = "PMD" + DateTime.Now.ToString("yy") + num.ToString("000000");
            }
            else if (type == "Role")
            {
                returnVal = "GA" + DateTime.Now.ToString("yy") + num.ToString("000000");
            }
            

        }


        return returnVal;
    }

    //상품 추천 코드 생성
    public static string NextGoodsRecommCode(string curCode, string gubun)
    {
        string returnVal = string.Empty;

        if (string.IsNullOrWhiteSpace(curCode))
        {
            returnVal += gubun + DateTime.Now.ToString("yyMMdd") + "0000000001";
        }
        else
        {
            int num = curCode.Substring(8, 10).AsInt() + 1;
            returnVal += returnVal = gubun + DateTime.Now.ToString("yyMMdd") + num.ToString("0000000000");
        }
        return returnVal;
    }
    
}