<%@ Page Language="C#" AutoEventWireup="true" CodeFile="kakaoTest.aspx.cs" Inherits="Test_kakaoTest" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
    <title></title>
    <script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
</head>
<body>
    <a id="kakao-link-btn" href="javascript:;">
        <img src="//developers.kakao.com/assets/img/about/logos/kakaolink/kakaolink_btn_medium.png" />
    </a>
    <script type='text/javascript'>
        // // 사용할 앱의 JavaScript 키를 설정해 주세요.
        Kakao.init('5b831352cc26bbadaee65f375a3b5def');
        // // 카카오링크 버튼을 생성합니다. 처음 한번만 호출하면 됩니다.
        Kakao.Link.createScrapButton({
            container: '#kakao-link-btn',
            requestUrl: 'https://developers.kakao.com'
        });
    </script>
</body>
</html>
