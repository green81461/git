<!--#include file="./class/NICELite.asp"-->

<% 
session.CodePage = 949
Response.CharSet = "euc-kr"
%>

<%
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <���� ��� ����>
' ����� ��� �ɼ��� ����� ȯ�濡 �µ��� �����ϼ���.
' �α� ���丮�� �� �����ϼ���.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Set NICEpay = new clssNICEpay
merchantKey = Request.Form("MerchantKey")  '����Ű
merchantID = Request.Form("MID")
encodeParameters = "CardNo,CardExpire,CardPwd"              '��ȣȭ����׸� (����Ұ�)
encryptData = Request.Form("EncryptData")

LogPath = Server.MapPath("/Logs/pay/")

NICEpay.setfield "logdir",LogPath                         'Log Path ����
NICEpay.setfield "type","CARD_ARS"                               '���񽺸�� ����(���� ���� : PY0 , ��� ���� : CL0)
NICEpay.setfield "EncodeKey",merchantKey                    '����Ű ����
NICEpay.setfield "NetCancelAmt",Request.Form("Amt")         '��� �ݾ� 
NICEpay.setfield "NetCancelPwd","rhdrka219"					'��������
NICEpay.setfield "mid",merchantID					'����ID


'���հ��� ����
NICEpay.setfield "SupplyAmt",Request.Form("SupplyAmt")
NICEpay.setfield "GoodsVat",Request.Form("GoodsVat")
NICEpay.setfield "ServiceAmt",Request.Form("ServiceAmt")
NICEpay.setfield "TaxFreeAmt",Request.Form("TaxFreeAmt")

NICEpay.startAction()

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <���� ��� �ʵ�>
' �Ʒ� ���� ������ �ܿ��� ���� Header�� ������ ������ Get ����
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
resultCode    = NICEpay.getResult("ResultCode")             '��� �ڵ�
resultMsg     = NICEpay.getResult("ResultMsg")	            '��� �޽���
resultErrCode = NICEpay.getResult("resulterrcode")          '��� ���� �ڵ�
tid           = NICEpay.getResult("TID")                    '�ŷ� ID
moid          = NICEpay.getResult("Moid")                   '�ֹ���ȣ
amt           = NICEpay.getResult("Amt")                    '����
payMethod     = NICEpay.getResult("PayMethod")              '��������
authDate      = NICEpay.getResult("AuthDate")               '���� ��¥
authCode      = NICEpay.getResult("AuthCode")               '���� ��ȣ
cardCode      = NICEpay.getResult("CardCode")               'ī��� �ڵ�
cardName      = NICEpay.getResult("CardName")               'ī����
cardQuota     = NICEpay.getResult("CardQuota")              '00:�Ͻú�,02:2����
bankCode      = NICEpay.getResult("BankCode")               '������ü ���� �ڵ�
bankName      = NICEpay.getResult("BankName")               '������ü �����
rcptType      = NICEpay.getResult("RcptType")               '���� ������(0:�����������,1:�ҵ����,2:��������)
rcptAuthCode  = NICEpay.getResult("RcptAuthCode")           '���ݿ����� ���� ��ȣ
rcptTID       = NICEpay.getResult("RcptTID")                '���� ������ TID   
carrier       = NICEpay.getResult("Carrier")                '����籸��
dstAddr       = NICEpay.getResult("DstAddr")                '�޴�����ȣ
vBankCode     = NICEpay.getResult("VbankBankCode")          '������������ڵ�
vBankName     = NICEpay.getResult("VbankBankName")          '������������
vbankNum      = NICEpay.getResult("VbankNum")               '������¹�ȣ
vbankExpDate  = NICEpay.getResult("VbankExpDate")           '��������Աݿ�����
goodsName     = NICEpay.getResult("GoodsName")

sUser = Request.Form("hdSvidUser")
payMethodFlag = Request.Form("PayMethodFlag")
payMethodName = Request.Form("PayMethodName")
goodsCnt = Request.Form("GoodsCnt")
saleComName = Request.Form("SaleComName")
buyerName = Request.Form("BuyerName")
buyerTel = Request.Form("BuyerTel")
buyerEmail = Request.Form("BuyerEmail")
price = Request.Form("Amt")
goodsName = Request.Form("GoodsName")
moid = Request.Form("Moid")


ediDate = getNow()

Function getNow()
Dim aDate(2), aTime(2)
    aDate(0) = Year(Now)
    aDate(1) = Right("0" & Month(Now), 2)
    aDate(2) = Right("0" & Day(Now), 2)
    aTime(0) = Right("0" & Hour(Now), 2)
    aTime(1) = Right("0" & Minute(Now), 2)
    aTime(2) = Right("0" & Second(Now), 2)	
    getNow   = aDate(0)&aDate(1)&aDate(2)&aTime(0)&aTime(1)&aTime(2)	   
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <���� ���� ���� Ȯ��>
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'paySuccess = False
'If payMethod = "CARD" Then
'	If resultCode = "3001" Then paySuccess  = True          '�ſ�ī��(���� ����ڵ�:3001)
'ElseIf  payMethod = "BANK" Then
'	If resultCode = "4000" Then paySuccess  = True 	        '������ü(���� ����ڵ�:4000)	
'ElseIf payMethod  = "CELLPHONE" Then
'	If resultCode = "A000" Then paySuccess  = True	        '�޴���(���� ����ڵ�:A000)
'ElseIf  payMethod = "VBANK" Then
'	If resultCode = "4100" Then paySuccess  = True	        '�������(���� ����ڵ�:4100)
'End If

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <Ŭ���� ����>
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Set NICEpay = Nothing
%>
<!DOCTYPE html>
<html>
<head>
<title>NICEPAY PAY RESULT(EUC-KR)</title>
<meta charset="euc-kr">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
<link href="../Content/NicePay/import.css" rel="stylesheet" />
<script src="../Scripts/jquery-1.10.2.min.js"></script>
<script>
    $(document).ready(function () {
        document.arsPayForm.acceptCharset = 'utf-8';
        document.arsPayForm.action = "PayResult";
        document.arsPayForm.submit();
    });

//    function nicepay() {
//        document.arsPayForm.acceptCharset = 'utf-8';
//        document.arsPayForm.action = "PayResult";
//        document.arsPayForm.submit();
//    }
</script>
</head>
<body>
<form name="arsPayForm" method="post" action="PayResult">
<!--  <div class="payfin_area">
      <div class="top">NICEPAY PAY REQUEST(EUC-KR)::ARS ���� ��û</div>
      <div class="conwrap">
        <div class="con">
          <div class="tabletypea">
            <table>-->
              <!--<colgroup><col style="width:30%" /><col style="width:auto" /></colgroup>-->
                <!--<tr>
                    <td>
                        <input type="hidden" name="txtResultCode" value="<%=resultCode %>">
                    </td>
                    <td>
                    <input type="hidden" name="txtResultMsg" value="<%=resultMsg %>">
                    </td>
                </tr>-->
			  <!--<tr>
                <th><span>* ���� ���̵�</span></th>
                <td><input type="hidden" name="MID" value="<%=merchantID%>"></td>
              </tr>
              <tr>
                <th><span>* ��ǰ��</span></th>
                <td><input type="hidden" name="GoodsName" value="<%=goodsName%>"></td>
              </tr>
			  <tr>
                <th><span>* ��ǰ�ֹ���ȣ</span></th>
                <td>
					<input type="hidden" name="Moid" value="<%=moid%>" style="width:210px">
					����ũ�� ���� �ֹ���ȣ (������+���� ���� ����)
				</td>
              </tr>
			  <tr>
                <th><span>* ���� ��ǰ�ݾ�</span></th>
                <td>
					<input type="hidden" name="Amt" value="<%=price%>">
					��ǰ �ݾ��� �ҽ� �󿡼� ���� (������ üũ)
				</td>
              </tr>	  			  
			  <tr>
                <th><span>* �����ڸ�</span></th>
                <td><input type="hidden" name="BuyerName" value="<%=buyerName%>"></td>
              </tr>
              <tr>
                <th><span>* ������ ��ȭ��ȣ</span></th>
                <td>
					<input type="hidden" name="BuyerTel" value="<%=buyerTel%>">
					SMS ������ ��ȭ ��ȣ �Դϴ�. ���ڸ� �Է� ��: 01012345678
				</td>
              </tr>
			  <tr>
                <th><span>������ �̸���</span></th>
                <td><input type="hidden" name="BuyerEmail" value="<%=buyerEmail%>"></td>
              </tr>-->
			  <!--<tr>
                <th><span>�����ڿ���</span></th>
                <td>
					<select name="CardInterest">
						<option value="0" selected>�Ϲ�</option>
						<option value="1">������</option>
					</select>
				</td>
              </tr>
			  <tr>
                <th><span>�Һΰ�����</span></th>
                <td>
					<select name="CardQuota">
					<%
						FOR i=0 TO 36 STEP 1
							optionText = ""
							optionValue = ""
							IF i <> 1 THEN
								IF i = 0 THEN 
									optionText = "�Ͻú�"
								ELSE 
									optionText = i & "����"
								END IF
							
								IF i < 10 THEN 
									optionValue = "0" & i
								ELSE 
									optionValue = i
								END IF
								
					%>
						<option value="<%=optionValue%>"><%=optionText%></option>
					<%
							END IF
							
						NEXT
					%>
					</select>
				</td>
              </tr>-->
			  <!--<tr>
                <th><span>* ARS ����</span></th>
                <td>-->
                    <input type="hidden" name="MID" value="<%=merchantID%>">
                    <input type="hidden" name="GoodsName" value="<%=goodsName%>">
                    <input type="hidden" name="Moid" value="<%=moid%>" style="width:210px">
                    <input type="hidden" name="Amt" value="<%=price%>">
                    <input type="hidden" name="BuyerName" value="<%=buyerName%>">
                    <input type="hidden" name="BuyerTel" value="<%=buyerTel%>">
                    <input type="hidden" name="BuyerEmail" value="<%=buyerEmail%>">


                    <input type="hidden" name="CardInterest" value="0"/>
                    <input type="hidden" name="CardQuota" value="00"/>

                    <!-- �ɼ� -->
                    <input type="hidden" name="VbankExpDate" value="<%=tomorrow%>"/>             <!-- ��������Աݸ����� -->
                    <input type="hidden" name="BuyerEmail" value="<%=buyerEmail%>"/>             <!-- ������ �̸��� -->				  
                    <input type="hidden" name="GoodsCl" value="1"/>                              <!-- ��ǰ����(�ǹ�(1),������(0)) -->  
                    <input type="hidden" name="TransType" value="0"/>                            <!-- �Ϲ�(0)/����ũ��(1) --> 
              
                    <!-- ���� �Ұ��� -->
                    <input type="hidden" name="EncodeParameters" value="<%=encodeParameters%>"/> <!-- ��ȣȭ����׸� -->
                    <input type="hidden" name="EdiDate" value="<%=ediDate%>"/>                   <!-- ���� �����Ͻ� -->
                    <input type="hidden" name="EncryptData" value="<%=encryptData%>"/>            <!-- �ؽ��� -->
                    <input type="hidden" name="TrKey" value=""/>                                 <!-- �ʵ常 �ʿ� -->
                    <input type="hidden" name="MerchantKey" value="<%=merchantKey%>"/>           <!-- ���� Ű -->

                    <input type="hidden" name="AuthDate" value="<%=authDate %>">
                    <input type="hidden" name="AuthCode" value="<%=authCode %>">
                    
                    <input type="hidden" name="SaleComName" value="<%=saleComName %>">

                    <input type="hidden" name="hdSvidUser" value="<%=sUser%>"/>
                    <input type="hidden" name="PayMethod" value="CARD_ARS">
                    <input type="hidden" name="PayMethodFlag" value="<%=payMethodFlag %>">
                    <input type="hidden" name="PayMethodName" value="<%=payMethodName %>">
                    <input type="hidden" name="GoodsCnt" value="<%=goodsCnt %>">
                    
                    <input type="hidden" name="hdResultCode" value="<%=resultCode %>">
                    <input type="hidden" name="hdResultMsg" value="<%=resultMsg %>">

					<input type="hidden" name="ArsReqType" value="SMS">
				<!--</td>
              </tr>
			  
            </table>
          </div>
        </div>-->
        <!--<div class="btngroup">
          <a href="#" class="btn_blue" onClick="nicepay();">�� û</a>
        </div>-->
      <!--</div>
    </div>-->
</form>
</body>
</html>
