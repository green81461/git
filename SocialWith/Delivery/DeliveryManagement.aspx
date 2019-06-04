<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="DeliveryManagement.aspx.cs" Inherits="Delivery_DeliveryManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../Content/Delivery/delivery.css" rel="stylesheet" />
    <style type="text/css">
	    .layer {display:none; position:fixed; _position:absolute; top:0; left:0; width:100%; height:100%; z-index:999;}
		.layer .bg {position:absolute; top:0; left:0; width:100%; height:100%; background:#000; opacity:.5; filter:alpha(opacity=50);}
		.layer .pop-layer {display:block;}

	    .pop-layer {display:none; position: absolute; top: 50%; left: 50%; width: 1300px; height:auto;  background-color:#fff; border: 3px solid black; z-index: 999;}	
	    .pop-layer .pop-container {padding: 20px 25px;}
	    
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#tblHeader").on("click", "input[type=checkbox]", function (eventData) {
                var checked = $(eventData.currentTarget).prop("checked");

                if (checked) {
                    $("#tblHeader input[type=checkbox]").prop("checked", false);//uncheck everything.
                    $(eventData.currentTarget).prop("checked", "checked");//recheck this one. 
                }
            });
        });
        function layer_open(el, compCode, compNo, areaName, areaCode, businessName, businessCode, deptName, deptCode, person){


            //텍스트 박스 초기화
            $('#<%= txtPostalCode.ClientID %>').val('');
            $('#<%= txtAddress1.ClientID %>').val('');
            $('#<%= txtAddress2.ClientID %>').val('');
		   
            var e = document.getElementById(el);
		     if (e.style.display == 'block') {
                e.style.display = 'none';

            }
            else {
                $(".popupdivWrapper").css('left', '0px');
                $(".popupdivWrapper").css('top', '0px');
                e.style.display = 'block';
                $(".popupdivWrapper").draggable();
            }

            //테이블 세팅

            var gubun = '<%= Gubun%>';
            switch (gubun) {
                case '3':
                    $('#tdModalHeaderBusiness').hide();
                    $('#tdModalBusiness').hide();
                    break;

                case '4':
                    $('#tdModalHeaderArea').hide();
                    $('#tdModalHeaderBusiness').hide();
                    $('#tdModalArea').hide();
                    $('#tdModalBusiness').hide();
                    break;
                default:
            }


            $('#<%= hfCompCode.ClientID %>').val(compCode);
            $('#<%= hfCompNo.ClientID %>').val(compNo);
            $('#<%= hfAreaCode.ClientID %>').val(areaCode);
            $('#<%= hfBusinessCode.ClientID %>').val(businessCode);
            $('#<%= hfDeptCode.ClientID %>').val(deptCode);
            $('#<%= hfPerson.ClientID %>').val(person);



            $('#<%= lblAreaName.ClientID %>').text(areaName);
            $('#<%= lblBusinessName.ClientID %>').text(businessName);
            $('#<%= lblDeptName.ClientID %>').text(deptName);
            $('#<%= lblPerson.ClientID %>').text(person);
        }		
        function fnValidation() {
            var txtPortalCode = $('#<%= txtPostalCode.ClientID %>');
            var txtAddress1 = $('#<%= txtAddress1.ClientID %>');
            var txtAddress2 = $('#<%= txtAddress2.ClientID %>');

            if (txtPortalCode.val() == '') {
                alert('우편번호를 입력하세요.');
                txtPortalCode.focus();
                return false;
            }

            if (txtAddress1.val() == '') {
                alert('주소를 입력하세요.');
                txtAddress1.focus();
                return false;
            }

            if (txtAddress2.val() == '') {
                alert('상세주소를 입력하세요.');
                txtAddress2.focus();
                return false;
            }
            return true;
        }

        function fnUpdateConfirm() {
            if (confirm('기본배송지를 변경하시겠습니까?')) {
                return true;
            }
            return false;
        }

        function fnDeleteConfirm(el) {

            if ($(el).parent().parent().find('input[id="hfDefault"]').val() == 'Y') {
                alert('기본배송지는 삭제할 수 없습니다.');
                return false;
            }
            if (confirm('삭제 하시겠습니까?')) {
                return true;
            }
            return false;
        }

        function fnCancel() {
            location.href = 'DeliveryList.aspx';
        }

        function fnModalClose() {
            $('#deliveryPopup').fadeOut();
        }
</script>
<script>
        //우편번호 팝업
    function openPostcode() {
            var width = 500; //팝업의 너비
            var height = 500; //팝업의 높이
            new daum.Postcode({
                width: width,
                height: height,
                oncomplete: function (data) {
                    // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                    // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                    // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                    var fullAddr = ''; // 최종 주소 변수
                    var extraAddr = ''; // 조합형 주소 변수

                    // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                    if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                        fullAddr = data.roadAddress;

                    } else { // 사용자가 지번 주소를 선택했을 경우(J)
                        fullAddr = data.jibunAddress;
                    }

                    // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
                    if (data.userSelectedType === 'R') {
                        //법정동명이 있을 경우 추가한다.
                        if (data.bname !== '') {
                            extraAddr += data.bname;
                        }
                        // 건물명이 있을 경우 추가한다.
                        if (data.buildingName !== '') {
                            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                        }
                        // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                        fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
                    }

                    // 우편번호와 주소 정보를 해당 필드에 넣는다.
                    $("#<%=txtPostalCode.ClientID%>").val(data.zonecode);
                    $("#<%=hfPostalCode.ClientID%>").val(data.zonecode);
                    $("#<%=txtAddress1.ClientID%>").val(fullAddr);
                    $("#<%=hfAddress1.ClientID%>").val(fullAddr);


                    //// 커서를 상세주소 필드로 이동한다.
                    $("#<%=txtAddress2.ClientID%>").focus();
                }
            }).open({
                left: (window.screen.width / 2) - (width / 2),
                top: (window.screen.height / 2) - (height / 2)
               }
            );
        }
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="sub-contents-div">
      <div class="sub-title-div">
                <img src="/images/DeliveryList_nam.png" />
        </div>
        <div>
        <!--리스트 시작-->
         <asp:ListView ID="lvDeliveryList" runat="server" ItemPlaceholderID="phItemList" OnItemDataBound="lvDeliveryList_ItemDataBound" OnItemCommand="lvDeliveryList_ItemCommand" OnItemDeleting="lvDeliveryList_ItemDeleting">
                    <LayoutTemplate>
                        <table id="tblHeader" class="tbl_main">
                            <colgroup class="">
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                            </colgroup>
                            <thead>
                                <tr class="">
                                    <th class="txt-center" style="height:40px;">구분</th>
                                    <th class="txt-center" style="width:50px;">기본<br />배송지</th>
                                    <th class="txt-center" runat="server" id="tdHeaderArea">사업장</th>
                                    <th class="txt-center" runat="server" id="tdHeaderBusiness">사업부</th>
                                    <th class="txt-center">부서명</th>
                                    <th class="txt-center">담당자</th>
                                    <th class="txt-center">우편번호</th>
                                    <th class="txt-center" style="width:400px;">주소</th>
                                    <th class="txt-center" style="width:200px;">상세주소</th>
                                    <th class="txt-center">삭제</th>
                                    <th class="txt-center">배송지추가</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:PlaceHolder ID="phItemList" runat="server" />
                            </tbody>
                        </table>
                    </LayoutTemplate>
                    <ItemTemplate>
                            <tr>
                                <td class="txt-center">
                                    <%# Eval("Delivery_No").ToString()%>
                                    <asp:HiddenField runat="server" ID="hfListSvidDelivery" Value='<%# Eval("Svid_Delivery").ToString() %>' />
                                    <asp:HiddenField runat="server" ID="hfListSvidUser" Value='<%# Eval("Svid_User").ToString() %>' />
                                    <asp:HiddenField runat="server" ID="hfListCompCode" Value='<%# Eval("Company_Code").ToString() %>' />
                                    <asp:HiddenField runat="server" ID="hfListCompAreaCode" Value='<%# Eval("CompanyArea_Code").ToString() %>' />
                                    <asp:HiddenField runat="server" ID="hfListCompBusinessCode" Value='<%# Eval("CompBusinessDept_Code").ToString() %>' />
                                    <asp:HiddenField runat="server" ID="hfListCompDeptCode" Value='<%# Eval("CompanyDept_Code").ToString() %>' />
                                    <input type="hidden" id="hfDefault" value='<%# Eval("DELIVERY_DEFAULT").ToString() %>' />
                                </td>
                                 <td class="txt-center">
                                    <asp:CheckBox runat="server" ID="chDefault" Checked='<%# Eval("DELIVERY_DEFAULT").ToString() == "Y" ? true : false %>' />
                                </td>
                               <td class="txt-center" runat="server" id="tdArea" visible='<%# AreaViewFlag  %>'>
                                    <%# Eval("CompanyArea_Name").ToString()%>
                                </td>
                                <td class="txt-center" runat="server" id="tdBusiness" visible='<%# BusinessViewFlag  %>'>
                                    <%# Eval("CompBusinessDept_Name").ToString()%>
                                </td>
                                <td class="txt-center">
                                    <%# Eval("CompanyDept_Name").ToString()%>
                                </td>
                                <td class="txt-center">
                                    <%# Eval("Delivery_Person").ToString()%>
                                </td>
                                <td class="txt-center">
                                    <%# Eval("Zipcode").ToString()%>
                                </td>
                                <td class="txt-center" style="text-align:left; padding-left:5px;">
                                    <%# Eval("Address_1").ToString()%>
                                </td>
                                <td class="txt-center" style="text-align:left; padding-left:5px;">
                                    <%# Eval("Address_2").ToString()%>
                                </td>
                                <td class="txt-center">
                                    <asp:ImageButton runat="server" ImageUrl="../Images/delivery/delete-off.jpg" onmouseover="this.src='../Images/delivery/delete-on.jpg'" onmouseout="this.src='../Images/delivery/delete-off.jpg'" ID="deleteDelivery" AlternateText="삭제"  OnClientClick="return fnDeleteConfirm(this);" CommandArgument='<%# Eval("Svid_Delivery").ToString() %>' CommandName="Delete"/>
                             
                                    </td>
                                <td class="txt-center">
                                    <asp:ImageButton runat="server" ImageUrl="../Images/delivery/add-off.jpg" onmouseover="this.src='../Images/delivery/add-on.jpg'" onmouseout="this.src='../Images/delivery/add-off.jpg'" ID="addDelivery" AlternateText="추가" OnClientClick='<%# string.Format("javascript:layer_open(\"deliveryPopup\", \"{0}\",\"{1}\",\"{2}\",\"{3}\",\"{4}\",\"{5}\",\"{6}\",\"{7}\",\"{8}\"); return false;", Eval("Company_Code").ToString(), Eval("Company_No").ToString(), Eval("CompanyArea_Name").ToString(), Eval("CompanyArea_Code").ToString(), Eval("CompBusinessDept_Name").ToString(), Eval("CompBusinessDept_Code").ToString(), Eval("CompanyDept_Name").ToString(), Eval("CompanyDept_Code").ToString(), Eval("Delivery_Person").ToString()) %>'/>
                                </td>
                            </tr>
                    </ItemTemplate>
                    <EmptyDataTemplate>
                        <table class="board-table">
                            <colgroup class="">
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                            </colgroup>
                            <thead>
                                <tr class="board-tr-height">
                                    <th class="txt-center">구분</th>
                                    <th class="txt-center">기본배송지선택</th>
                                    <th class="txt-center" runat="server" id="tdHeaderArea">사업장</th>
                                    <th class="txt-center" runat="server" id="tdHeaderBusiness">사업부</th>
                                    <th class="txt-center">부서명</th>
                                    <th class="txt-center">담당자</th>
                                    <th class="txt-center">우편번호</th>
                                    <th class="txt-center">주소</th>
                                    <th class="txt-center">상세주소</th>
                                    <th class="txt-center">삭제</th>
                                    <th class="txt-center">배송지추가</th>
                                </tr>
                            </thead>
                            <tr class="board-tr-height">
                                <td colspan="11" style="text-align:center;" >조회된 데이터가 없습니다.</td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                </asp:ListView>
                <!--리스트 끝-->
       <div class="btn">
            <asp:Button ID="btnExcelExport" runat="server"  OnClientClick="fnCancel(); return false;" Text="취소" CssClass="mainbtn type1" Width="95" Height="30"/>
            <asp:Button ID="btnDefaultUpdate" runat="server" OnClick="btnDefaultUpdate_Click" OnClientClick="return fnUpdateConfirm();" Text="기본 배송지 변경" CssClass="mainbtn type1" Width="125" Height="30"/>
        
       </div>
      
       </div>
        <div class="left-menu-wrap" id="divLeftMenu">
	        <dl>
		         <dt style="border-bottom:1px solid #eaeaea;">
			        <strong>마이페이지</strong>
		        </dt>
		        <dd>
                        <a href="/Order/OrderHistoryList.aspx">주문조회</a> 
                    </dd>
                    <dd>
                        <a href="/Delivery/DeliveryOrderList.aspx">배송조회</a> 
                    </dd>
                    <dd>
                        <a href="/Order/OrderBillIssue.aspx">세금계산서 조회</a> 
                    </dd>
                    <dd>
                        <a href="/Member/MemberEditCheck.aspx">마이정보변경</a> 
                    </dd>
                    <dd class="active">
                        <a href="/Delivery/DeliveryList.aspx">배송지관리</a> 
                    </dd>
	        </dl>
        </div>
    </div>
    <!--팝업 레이어 시작-->
    <div id="deliveryPopup" class="popupdiv divpopup-layer-package" >
	    <div class="popupdivWrapper" style="width:70%; " >
		    <div class="popupdivContents" style="height:300px; " >
                    <h3>추가배송지 입력</h3>
			        <table class="tbl_popup">
                        <colgroup>
                            <col style="width:80px;"/>
                            <col style="width:80px;"/>
                            <col style="width:150px;"/>
                            <col style="width:250px;"/>
                            <col style="width:200px;"/>

                        </colgroup>
                        <tr>
                            <th class="txt-center" id="tdModalHeaderArea">
                                사업장
                            </th>
                            <th class="txt-center" id="tdModalHeaderBusiness">
                                사업부
                            </th>
                            <th class="txt-center">
                                부서명
                            </th>
                            <th class="txt-center">
                                담당자
                            </th>
                            <th class="txt-center">
                                우편번호
                            </th>
                            <th class="txt-center">
                                주소
                            </th>
                            <th class="txt-center">
                                상세주소
                            </th>
                        </tr>
                        <tr>
                            <td class="txt-center" id="tdModalArea">
                                <asp:Label runat="server" ID="lblAreaName"></asp:Label>
                            </td>
                            <td class="txt-center" id="tdModalBusiness">
                                <asp:Label runat="server" ID="lblBusinessName"></asp:Label>
                            </td>
                            <td class="txt-center">
                                <asp:Label runat="server" ID="lblDeptName"></asp:Label>
                            </td>
                            <td class="txt-center">
                                <asp:Label runat="server" ID="lblPerson"></asp:Label>
                            </td>
                            <td class="txt-center">
                                <asp:TextBox runat="server" ID="txtPostalCode" ReadOnly="true" CssClass="zipcode"></asp:TextBox>
                                
                                
                            <img src="../Images/Goods/zipcode-btn.jpg"  onclick="openPostcode()" alt="우편번호검색" />    
                            
                            </td>
                            <td class="txt-center">
                                <asp:TextBox runat="server" ID="txtAddress1" ReadOnly="true" CssClass="addr1"></asp:TextBox>
                               
                            </td>
                            <td class="txt-center">
                                <asp:TextBox runat="server" ID="txtAddress2" CssClass="addr2"></asp:TextBox>
                            </td>
                        </tr>
			        </table>
                     <asp:HiddenField runat="server" ID="hfCompCode" />
                     <asp:HiddenField runat="server" ID="hfCompNo" />
                     <asp:HiddenField runat="server" ID="hfAreaCode" />
                     <asp:HiddenField runat="server" ID="hfBusinessCode" />
                     <asp:HiddenField runat="server" ID="hfDeptCode" />
                     <asp:HiddenField runat="server" ID="hfPerson" />
                     <asp:HiddenField runat="server" ID="hfPostalCode" />
                     <asp:HiddenField runat="server" ID="hfAddress1" />
                    <br />
                    <div class="btn">
                         <asp:Button ID="btnCancel" runat="server"  OnClientClick="fnModalClose(); return false;" Text="취소" CssClass="mainbtn type1" Width="95" Height="30"/>
                         <asp:Button ID="btnAdd" runat="server" OnClick="btnAdd_Click" OnClientClick="return fnValidation();" Text="추가" CssClass="mainbtn type1" Width="95" Height="30"/>
			    </div>
		    </div>
	    </div>
    </div>
    <!--팝업 레이어 끝-->
 </asp:Content>

