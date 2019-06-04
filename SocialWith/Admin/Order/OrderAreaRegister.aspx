<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OrderAreaRegister.aspx.cs" Inherits="Admin_Order_OrderAreaRegister" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
   <%--<link href="../Content/order/order.css" rel="stylesheet" />--%>
   <link href="../Content/goods/goods.css" rel="stylesheet" />

    <style>
        .tab-display1 {
            margin-top: 40px;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            var tableid = "tblHeader";
            ListCheckboxOnlyOne(tableid);

            fnOrderAreaCodeList();

        });

        function fnEnter() {

            if (event.keyCode == 13) {
                fnSearchPopup();
                return false;
            }
            else
                return true;
        }

        function fnOrderAreaCodeList() {

            var callback = function (response) {

                // $('#SearchTarget').prepend('<option value="">--선택--</option>');

                for (var i = 0; i < response.length; i++) {

                    var createHtml = '';

                    if (response[i].Map_Type != 0) {
                        createHtml = '<option value="' + response[i].Map_Name + '">' + "0" + response[i].Map_Type + '</option>';
                        if (i == 1) {
                            $("#tdOrderAreaName").text(response[i].Map_Name);
                            $("#hdAreaCode").text("0" + response[i].Map_Type);
                        }
                        $('#SearchTarget').append(createHtml);
                    }
                }
                return false;
            }
            var sUser = '<%=Svid_User %>';
            var param = {
                Method: 'GetCommList',
                Code: 'ORDER',
                Channel: 3
            };

            JajaxSessionCheck('Post', '../../Handler/Common/CommHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }

        function fnChangeOrderAreaCode() {
            var value = $("#SearchTarget").val();
            $("#tdOrderAreaName").text(value);
            var target = $("#SearchTarget option:selected").text();
            $("#hdAreaCode").text(target);
        }

        function fnSearchPopup() {

            var txtSearchKeyword = $("#txtSearchKeyword2").val();

            var callback = function (response) {
                $('#tblHeader tbody').empty(); //테이블 클리어
                var newRowContent = "";

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가
                        newRowContent += "<tr>";
                        newRowContent += "<td style='width: 50px' class='txt-center'><input type='checkbox' id='cbSelect'/></td>";  //선택          
                        newRowContent += "<td id='Belong_Name' style='width: 100px' class='txt-center'>" + value.OrderBelongName + "</td>"; //소속명         
                        newRowContent += "<td id='Belong_Code' style='width: 100px' class='txt-center'>" + value.OrderBelongCode + "</td> </tr>"; //소속코드
                    });
                } else {
                    newRowContent += "<tr><td colspan='3' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                }
                $('#tblHeader tbody').append(newRowContent);

                //var e = document.getElementById('orderBelongCodediv');
                //e.style.display = 'block';

                fnOpenDivLayerPopup('orderBelongCodediv');


                return false;
            }
            var sUser = '<%=Svid_User %>';
            var param = {
                Method: 'OrderBelongPopupList',
                SearchKeyword: txtSearchKeyword
            };

            JajaxSessionCheck('Post', '../../Handler/OrderHandler.ashx', param, 'json', callback, '<%=Svid_User%>');

            return false;
        }

       

        function fnClick_Ok() {
            $('#tblHeader tbody tr').each(function (index, element) {
                if ($(this).find("input[type = checkbox]").prop('checked') == true) {
                    var name = $(this).find("#Belong_Name").text();
                    var code = $(this).find("#Belong_Code").text();
                    $("#tdOrderBelongName").text(name);
                    $("#txtSearchKeyword").val(code);
                }
            });
            
            fnClosePopup('orderBelongCodediv');
        }

        function fnSave() {
            if (fnValidation()) {
                var orderBelongCode = $("#txtSearchKeyword").val();
                var orderAreaName = $("#SearchTarget").val();
                var orderAreaCode = $("#hdAreaCode").text();
                var remark = $("#textareaRemark").val();

                var callback = function (response) {
                    if (response == '1') {
                        alert('저장되었습니다.');
                        location.href = 'OrderAreaList.aspx';
                    }
                    else if (response == '2') {
                        alert('값이 중복되어 저장할 수 없습니다.');

                    } else {
                        alert('시스템 오류입니다. 관리자에게 문의하세요.');
                    }
                    return false;
                }

                var sUser = '<%=Svid_User %>';

                var param = {
                    Method: 'SaveOrderArea',
                    OrderBelongCode: orderBelongCode,
                    OrderAreaCode: orderAreaCode,
                    OrderAreaName: orderAreaName,
                    Remark: remark
                };

                JajaxSessionCheck('Post', '../../Handler/OrderHandler.ashx', param, 'json', callback, '<%=Svid_User%>');

                return false;

            }

        }

        function fnValidation() {

            var txtSearchKeyword = $("#txtSearchKeyword").val();
            var searchTarget = $("#SearchTarget").val();

            if (txtSearchKeyword == '') {
                alert('주문소속코드는 필수 입력 항목입니다.');
                $("#txtSearchKeyword").focus();
                return false;
            }

            if (searchTarget == '') {
                alert('주문지역코드는 필수 선택사항입니다.');
                $("#SearchTarget").focus();
                return false;
            }
            return true;
        }

        //페이지 이동
        function fnGoPage(pageVal) {
            switch (pageVal) {
                case "OHL":
                    window.location.href = "../Order/OrderHistoryList?ucode=" + ucode;
                    break;
                case "DL":
                    window.location.href = "../Order/DeliveryOrderList?ucode=" + ucode;
                    break;
                case "PG":
                    window.location.href = "../Member/Pg_Main?ucode=" + ucode;
                    break;
                case "LOAN":
                    window.location.href = "../Member/Loan_Main?ucode=" + ucode;
                    break;
                case "OBM":
                    window.location.href = "../Order/OrderBelongMain?ucode=" + ucode;
                    break;
                case "CLM":
                    window.location.href = "../Company/CompanyLinkManagement?ucode=" + ucode;
                    break;
                default:
                    break;

            }
        }


        function fnTabClickRedirect(pageName) {
            location.href = pageName + '.aspx?ucode=' + ucode;
            return false;
        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">

        <div class="sub-contents-div">
            <!--제목 타이틀-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    주문연동관리
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
            <br />
            <!--상위 탭메뉴-->
            <div>
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="관계사 연동 관리" onclick="fnGoPage('CLM')" />
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="PG 관리" onclick="fnGoPage('PG')" />
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="여신 관리" onclick="fnGoPage('LOAN')" />
            </div>


            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OrderBelongMain');">
                        <a onclick="fnTabClickRedirect('OrderBelongMain');">주문 소속</a>
                    </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('OrderAreaList');">
                        <a onclick="fnTabClickRedirect('OrderAreaList');">주문 지역</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OrderSaleCompList');">
                        <a onclick="fnTabClickRedirect('OrderSaleCompList');">주문 업체</a>
                    </li>
                </ul>
            </div>

            <!--하위 탭메뉴-->
            <div class="tab-display1">
                <div class="tab" style="margin-top: 10px">
                    <span class="subTabOff" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab1" onclick="fnTabClickRedirect('OrderAreaList.aspx');">주문 지역 조회</span>
                    <span class="subTabOn" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab2" onclick="fnTabClickRedirect('OrderAreaRegister.aspx');">주문 지역 등록</span>

                    <%--<a class="tabButton1"  id="btnTab1" onclick="javascript:location.href='OrderAreaList.aspx';">
                  <img src="../../Images/Order/belongTsub-off.jpg" alt="주문 지역 조회"  /></a> 
                    <a class="tabButton2"  id="btnTab2" onclick="javascript:location.href='OrderAreaRegister.aspx';">
                   <img src="../../Images/Order/belongT2sub-on.jpg" alt="주문 지역 등록"  /></a>--%>
                </div>
            </div>


            <!--상단영역 시작-->
            <div class="OrderSearch-div" style="margin-top: 30px">
                <table id="tblSearchB" class="tbl_main">
                    <tr>
                        <th colspan="4" style="height: 50px">
                            주문 지역 등록
                        </th>
                    </tr>
                    <tr>
                        <th>*&nbsp;주문 소속 코드</th>
                        <td style="width: 30%">
                            <input type="text" id="txtSearchKeyword" placeholder="검색어를 입력하세요" style="width:75%;" onkeypress="return fnEnter();" readonly="readonly" />
                            <input type="button" class="mainbtn type1" onclick="return fnSearchPopup()" value="검색" style="width:75px"/>
                        </td>
                        <th>주문소속명</th>
                        <td id="tdOrderBelongName" style="width: 30%"></td>
                    </tr>

                    <tr>
                        <th>*&nbsp;주문 지역 코드</th>
                        <td>
                            <select id="SearchTarget" class="dropA2" onchange="return fnChangeOrderAreaCode();">
                            </select>
                            <input type="hidden" id="hdAreaCode" />
                        </td>
                        <th>주문지역명</th>
                        <td id="tdOrderAreaName"></td>
                    </tr>

                    <tr>
                        <td colspan="4">
                            <label style="padding: 10px; float: left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;비고</label>
                            <div>
                                <textarea style="width: 96%; height: 50px; margin-left: 25px; margin-right: 25px; margin-bottom: 25px; resize: none; border: 1px solid #a2a2a2" id="textareaRemark"></textarea>
                            </div>

                        </td>
                    </tr>
                </table>
                <div style="float: right; margin-top: 30px;">
                     <input type="button" onclick="return fnSave()" class="mainbtn type1" value="등록" style="width:75px;"/>
                </div>
            </div>
            <!--상단영역 끝-->

        </div>
    </div>

    <!-- 팝업창 -->
    <div id="orderBelongCodediv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width:700px;">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('orderBelongCodediv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title" style="margin-top: 20px;">
                    <h3 class="pop-title">주문소속 조회</h3>
                    <%--<div class="sub-title-div">
                        <p class="p-title-mainsentence">
                            주문소속 조회
                    <span class="span-title-subsentence"></span>
                        </p>
                    </div>--%>
                 



                    <div class="search-div" style="margin-bottom: 20px;">
                        <input type="text" class="text-code" id="txtSearchKeyword2" style="width:400px;" placeholder="주문소속명을 입력하세요" onkeypress="return fnEnter();" />
                        <%--<a class="imgA">
                            <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" alt="검색" class="mainbtn type1" /></a>--%>
                        <input type="button" class="mainbtn type1" style="width: 75px;" value="검색" onclick="return fnSearchPopup();" />
                    </div>


                    <div class="divpopup-layer-conts" style="overflow-y: auto; height: 300px">

                        <table id="tblHeader" class="tbl_main tbl_popup" style="margin-top: 0; width: 100%">

                            <thead>
                                <tr>
                                    <th class="text-center" style="width: 10%">선택</th>
                                    <th class="text-center">소속명</th>
                                    <th class="text-center">소속코드</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td colspan="3" class="text-center">리스트가 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>


                    </div>

                    <div style="text-align: right; margin-top: 30px;">
                        <%--<a onclick="fnClick_Ok()">
                            <img src="../Images/Goods/submit1-off.jpg" alt="확인" class="mainbtn type1" /></a>--%>
                     <input type="button" class="mainbtn type1" style="width:75px;" value="확인" onclick="fnClick_Ok();" />

                    </div>

                </div>
            </div>
        </div>
    </div>
</asp:Content>

