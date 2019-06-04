using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using NLog;

/// <summary>
/// Crypt의 요약 설명입니다.
/// </summary>
public class Crypt
{

    #region << logger >>
    private static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    private static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    private static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    private static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    private static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    private static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    public Crypt()
    {
        //
        // TODO: 여기에 생성자 논리를 추가합니다.
        //
    }

    public static string MD5Encryption(String password)
    {
        MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
        byte[] encrypt;
        UTF8Encoding encode = new UTF8Encoding();
        encrypt = md5.ComputeHash(encode.GetBytes(password));
        StringBuilder encryptdata = new StringBuilder();
        for (int i = 0; i < encrypt.Length; i++)
        {
            encryptdata.Append(encrypt[i].ToString());
        }
        return encryptdata.ToString();
    }

    //다아라몰용 MD5
    public static string GetDaaraMd5Hash(string input)
    {
        MD5 md5Hash = MD5.Create();

        // Convert the input string to a byte array and compute the hash.
        byte[] data = md5Hash.ComputeHash(Encoding.UTF8.GetBytes(input));

        // Create a new Stringbuilder to collect the bytes
        // and create a string.
        StringBuilder sBuilder = new StringBuilder();

        // Loop through each byte of the hashed data 
        // and format each one as a hexadecimal string.
        for (int i = 0; i < data.Length; i++)
        {
            sBuilder.Append(data[i].ToString("x2"));
            //sBuilder.Append(data[i].ToString());
        }

        // Return the hexadecimal string.
        return sBuilder.ToString();
    }
    
    private static readonly string defaultKeyASE256 = "a99b4d2917b248bd8a036ef761b6a930";
    private static readonly string daaraKeyAES256   = "V^cD=&SNmVbsJ_lbBG90He2fkS-Y74KI"; //다아라몰에서 제공한 API KEY

    public static String AESEncrypt256(string Input)
    {
        RijndaelManaged aes = new RijndaelManaged();
        aes.KeySize = 256;
        aes.BlockSize = 128;
        aes.Mode = CipherMode.CBC;
        aes.Padding = PaddingMode.PKCS7;
        aes.Key = Encoding.UTF8.GetBytes(defaultKeyASE256);
        aes.IV = new byte[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

        var encrypt = aes.CreateEncryptor(aes.Key, aes.IV);
        byte[] xBuff = null;
        using (var ms = new MemoryStream())
        {
            using (var cs = new CryptoStream(ms, encrypt, CryptoStreamMode.Write))
            {
                byte[] xXml = Encoding.UTF8.GetBytes(Input);
                cs.Write(xXml, 0, xXml.Length);
            }

            xBuff = ms.ToArray();
        }

        String Output = Convert.ToBase64String(xBuff);
        return Output;
    }

    // 복호화
    public static String AESDecrypt256(string Input)
    {
        RijndaelManaged aes = new RijndaelManaged();
        aes.KeySize = 256;
        aes.BlockSize = 128;
        aes.Mode = CipherMode.CBC;
        aes.Padding = PaddingMode.PKCS7;
        aes.Key = Encoding.UTF8.GetBytes(defaultKeyASE256);
        aes.IV = new byte[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

        var decrypt = aes.CreateDecryptor();
        byte[] xBuff = null;
        using (var ms = new MemoryStream())
        {
            using (var cs = new CryptoStream(ms, decrypt, CryptoStreamMode.Write))
            {
                byte[] xXml = Convert.FromBase64String(Input);
                cs.Write(xXml, 0, xXml.Length);
            }

            xBuff = ms.ToArray();
        }

        String Output = Encoding.UTF8.GetString(xBuff);
        return Output;
    }

    //다아라몰용 AES256 암호화
    public static String DaaraAESEncrypt256(string Input)
    {
        RijndaelManaged aes = new RijndaelManaged();
        aes.KeySize = 256;
        aes.BlockSize = 128;
        aes.Mode = CipherMode.CBC;
        aes.Padding = PaddingMode.PKCS7;
        aes.Key = Encoding.UTF8.GetBytes(daaraKeyAES256);
        aes.IV = Encoding.UTF8.GetBytes("864b6ab62938596c");
        var encrypt = aes.CreateEncryptor(aes.Key, aes.IV);
        
        byte[] xBuff = null;
        using (var ms = new MemoryStream())
        {
            using (var cs = new CryptoStream(ms, encrypt, CryptoStreamMode.Write))
            {
                byte[] xXml = Encoding.UTF8.GetBytes(Input);
                cs.Write(xXml, 0, xXml.Length);
            }

            xBuff = ms.ToArray();
        }

        String Output = Convert.ToBase64String(xBuff);


        var tmpBytes = Encoding.UTF8.GetBytes(Output);
        string resultVal = Convert.ToBase64String(tmpBytes);

        return resultVal;
    }
}