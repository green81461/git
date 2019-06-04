<%@Language="VBScript" CODEPAGE="949"%>
<!--#include file="./class/SHA256.asp"-->
<%
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <������û �Ķ����>
' ������ Form �� ������ ������û �Ķ�����Դϴ�.
' ���������������� �⺻(�ʼ�) �Ķ���͸� ���õǾ� ������, 
' �߰� ������ �ɼ� �Ķ���ʹ� �����޴����� �����ϼ���.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
merchantKey      = "s85N0j9+7EQc/Ew1MRfKaLpAW2e6ydFMA2MmB5L2MqVvKUrsChzwbBcGPEwkHetGTwGEHXtT7pjlPceOWoWP4g=="  '����Ű
merchantID       = "nisocial2m"                             '�������̵�
goodsCnt         = "1"                                      '������ǰ����
goodsName        = "�ҼȰ����׽�Ʈ ��ǰ"                             '������ǰ��
price            = "1004"                                   '������ǰ�ݾ�
buyerName        = "���̽�"                                 '�����ڸ�
buyerTel         = "01087046370"                            '�����ڿ���ó
buyerEmail       = "rjh@socialwith.co.kr"                        '�����ڸ����ּ�
moid             = getMoid()                        		'��ǰ�ֹ���ȣ (����ũ�� ���� �ֹ���ȣ)
encodeParameters = "CardNo,CardExpire,CardPwd"              '��ȣȭ����׸� (����Ұ�)


'SupplyAmt = request.Form("SupplyAmt") '���ް���
'GoodsVat = request.Form("GoodsVat")   '�ΰ���
'ServiceAmt = request.Form("ServiceAmt")'�����
'TaxFreeAmt = request.Form("TaxFreeAmt")'�鼼�ݾ�


''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <������� �Ա� ������>
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
tomorrow = (date()+1)
tomorrow = Replace(tomorrow, "-", "")

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <�ؽ���ȣȭ> (�������� ������)
' SHA256 �ؽ���ȣȭ�� �ŷ� �������� �������� ����Դϴ�. 
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
call initCodecs

ediDate = getNow()
hashString = SHA256_Encrypt(ediDate & merchantID & price & merchantKey)

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

' ����ũ�� �ֹ���ȣ(Moid)�� �����ϱ� ���� �Լ�
' ���������� ���� ��Ģ�� ����� ���� ���� �մϴ�.
Function getMoid()
	getMoid = merchantID & "_" & getNow() & right("000" & (timer * 1000) Mod 1000, 3)
End Function
%>
<!DOCTYPE html>
<html>
<head>
<title>NICEPAY PAY REQUEST(EUC-KR)</title>
<meta charset="euc-kr">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
<link rel="stylesheet" type="text/css" href="./css/import.css"/>
<script src="https://web.nicepay.co.kr/flex/js/nicepay_tr_utf.js" type="text/javascript"></script>
<script type="text/javascript">
/**
nicepay	�� ���� ������ �����մϴ�.
@param	form :	���� Form 
*/
function nicepay() {
	var payForm		= document.payForm;
	payForm.submit();
}
</script>
</head>
<body>
<form name="payForm" method="post" action="arsPayResult.asp">
    <div class="payfin_area">
      <div class="top">NICEPAY PAY REQUEST(EUC-KR)::ARS ���� ��û</div>
      <div class="conwrap">
        <div class="con">
          <div class="tabletypea">
            <table>
              <colgroup><col style="width:30%" /><col style="width:auto" /></colgroup>
			  <tr>
                <th><span>* ���� ���̵�</span></th>
                <td><input type="text" name="MID" value="<%=merchantID%>"></td>
              </tr>
              <tr>
                <th><span>* ��ǰ��</span></th>
                <td><input type="text" name="GoodsName" value="<%=goodsName%>"></td>
              </tr>
			  <tr>
                <th><span>* ��ǰ�ֹ���ȣ</span></th>
                <td>
					<input type="text" name="Moid" value="<%=moid%>" style="width:210px">
					����ũ�� ���� �ֹ���ȣ (������+���� ���� ����)
				</td>
              </tr>
			  <tr>
                <th><span>* ���� ��ǰ�ݾ�</span></th>
                <td>
					<input type="text" name="Amt" value="<%=price%>">
					��ǰ �ݾ��� �ҽ� �󿡼� ���� (������ üũ)
				</td>
              </tr>	  			  
			  <tr>
                <th><span>* �����ڸ�</span></th>
                <td><input type="text" name="BuyerName" value="<%=buyerName%>"></td>
              </tr>
              <tr>
                <th><span>* ������ ��ȭ��ȣ</span></th>
                <td>
					<input type="text" name="BuyerTel" value="">
					SMS ������ ��ȭ ��ȣ �Դϴ�. ���ڸ� �Է� ��: 01012345678
				</td>
              </tr>
			  <tr>
                <th><span>������ �̸���</span></th>
                <td><input type="text" name="BuyerEmail" value="<%=buyerEmail%>"></td>
              </tr>
			  <tr>
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
              </tr>
			  <tr>
                <th><span>* ARS ����</span></th>
                <td>
                    <!-- �ɼ� -->
                    <input type="hidden" name="VbankExpDate" value="<%=tomorrow%>"/>             <!-- ��������Աݸ����� -->
                    <input type="hidden" name="BuyerEmail" value="<%=buyerEmail%>"/>             <!-- ������ �̸��� -->				  
                    <input type="hidden" name="GoodsCl" value="1"/>                              <!-- ��ǰ����(�ǹ�(1),������(0)) -->  
                    <input type="hidden" name="TransType" value="0"/>                            <!-- �Ϲ�(0)/����ũ��(1) --> 
              
                    <!-- ���� �Ұ��� -->
                    <input type="hidden" name="EncodeParameters" value="<%=encodeParameters%>"/> <!-- ��ȣȭ����׸� -->
                    <input type="hidden" name="EdiDate" value="<%=ediDate%>"/>                   <!-- ���� �����Ͻ� -->
                    <input type="hidden" name="EncryptData" value="<%=hashString%>"/>            <!-- �ؽ��� -->
                    <input type="hidden" name="TrKey" value=""/>                                 <!-- �ʵ常 �ʿ� -->
                    <input type="hidden" name="MerchantKey" value="<%=merchantKey%>"/>           <!-- ���� Ű -->


					<input type="text" name="ArsReqType" value="SMS">
					ȣ��ȯ : ARS, SMS ���� : SMS
				</td>
              </tr>
			  
            </table>
          </div>
        </div>
        <div class="btngroup">
          <a href="#" class="btn_blue" onClick="nicepay();">�� û</a>
        </div>
      </div>
    </div>
</form>
</body>
</html>