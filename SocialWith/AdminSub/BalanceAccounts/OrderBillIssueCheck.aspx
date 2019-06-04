<%@ Page Title="" Language="C#" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" AutoEventWireup="true" CodeFile="OrderBillIssueCheck.aspx.cs" Inherits="AdminSub_BalanceAccounts_OrderBillIssueCheck" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
        <link href="../../AdminSub/Contents/Order/order.css" rel="stylesheet" />
      <style>
  .sub-tab-div a:nth-child(1) {
        margin-left:0;
    }

    .sub-tab-div a:nth-child(2) {
        margin-left: -2.5px;
    }

    .sub-tab-div a:nth-child(3) {
        margin-left: -2.5px;
    }


    .sub-tab-div a:nth-child(4) {
        margin-left: -2px;
    }
    .sub-tab-div a:nth-child(5) {
        margin-left: -3px;
    }
  
    </style>
    <script type="text/javascript">
          var qs = fnGetQueryStrings();
        var ucode = qs["ucode"];
        $(document).ready(function () {
            var date = new Date();
            var firstDate = new Date(date.getFullYear(), date.getMonth(), 1);

            //검색창에서 달력 관련 기능
            $("#<%=this.txtSearchSdate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage: "../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true,
            });


            //$("#searchEndDate").val((new Date()).yyyymmdd());
            $("#<%=this.txtSearchEdate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage: "../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true,
            });

            // enter key 방지
            $(document).on("keypress", "#tblSearch input", function (e) {
                if (e.keyCode == 13) {
                    return false;
                }
                else
                    return true;
            });
            fnSearch(1);

            $('.div-main-tab > ul > li').click(function () {
                if ($(this).attr('id') == 'libs') {
                    $(this).attr('onClick', "location.href='BalanceSummary.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'BalanceSummary.aspx?ucode='+ucode+'');
                }
                else if ($(this).attr('id') == 'lipl') {
                    $(this).attr('onClick', "location.href='ProfitList.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'ProfitList.aspx?ucode='+ucode+'');
                }
                else if ($(this).attr('id') == 'lirl') {
                    $(this).attr('onClick', "location.href='ReturnList.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'ReturnList.aspx?ucode='+ucode+'');
                }
                else if ($(this).attr('id') == 'liob') {
                    $(this).attr('onClick', "location.href='OrderBillIssueCheck.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'OrderBillIssueCheck.aspx?ucode='+ucode+'');
                }
                else if ($(this).attr('id') == 'lipay') {
                    $(this).attr('onClick', "location.href='BillPayment.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'BillPayment.aspx?ucode='+ucode+'');
                }
            })

        });

        //바로가기
        function fnBillPopup(el, flag) {

            //var width = 700;
            //var height = 800;
            //var popupX = (window.screen.width / 2) - (width / 2);
            //var popupY = (window.screen.height / 2) - (height / 2);

            //if ($('#hdPrintPayway').val() == '1') {
            //    alert('신용카드는 영수증 제공이 안됩니다.');
            //    return false;
            //}
            var obj = $(el).parent();
            var billNo = $(obj).find("input:hidden[name='hdBillNo']").val(); //과세
            var MD5 = $(obj).find("input:hidden[name='hdMD5']").val(); //과세

            //면세인 경우
            if (flag == 2) {
                billNo = $(obj).find("input:hidden[name='hdzBillNo']").val();
                MD5 = $(obj).find("input:hidden[name='hdzMD5']").val();
            }

            if (isEmpty(billNo) || isEmpty(MD5)) {
                alert('세금명세서 확인이 불가한 거래 입니다.');
                return false;
            }

            var url = 'http://www.sendbill.co.kr/PreView?seq=' + billNo + "&cert=" + MD5 + "&VenderCheck=N&PR_DIV=R";

            var width = 700;
            var height = 800;
            var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
            var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

            var getwidth = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
            var getheight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

            var left = ((getwidth / 2) - (width / 2)) + dualScreenLeft;
            var top = ((getheight / 2) - (height / 2)) + dualScreenTop;

            window.open(url, '', "width=" + width + ",height=" + height + ",status=no ,toolbar=no,menubar=no,location=no,resizable=no,scrollbars=yes,left=" + left + ", top=" + top + "");

            //url, target, width, height, status, toolbar,  menubar, location, resizable, scrollbar
            //window.open(url, '', "height=" + height + ", width=" + width + ",status=yes,toolbar=no,menubar=no,location=no,resizable=no, scrollbars=yes,left=" + popupX + ", top=" + popupY + ", screenX=" + popupX + ", screenY= " + popupY + "");
            return false;
        }

        function fnPopupDataBind(pageNo) {
            var svidUser = '<%= Svid_User %>';
            //var pageNum = 1;
            //var hdPayNo = $(event).find("#hdPayNo").val();
            //var Amt = $(event).find("#hdAmt").val();
            var hdPayNo = $("#hdSelectPopPayNo").val();
            var Amt = $("#hdSelectPopAmt").val();
            Amt = numberWithCommas(Amt);
            var pageSize = 5;
            var i = 1;
            var asynTable = "";

            $("#tblPopup tbody").empty();

            var callback = function (response) {

                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {
                        $("#hdPopupTotalCount").val(value.TotalCount);

                        $("#lblTotCost").text(Amt + "원");

                        //구분자 붙이기
                        var MainCodeNo = value.MainCodeNo;
                        MainCodeNo = MainCodeNo.substr(0, 2);
                        var PayConfirmDate = value.PayConfirmDate.split("T")[0];
                        var EntryDate = value.EntryDate.split("T")[0];
                        var MainNo = value.MainCodeNo;
                        var GoodsFinalName = value.GoodsFinalName;
                        var CustAmt = numberWithCommas(value.CustAmt);

                        switch (MainCodeNo) {
                            case "ON":
                                PayConfirmDate = "*" + PayConfirmDate;
                                EntryDate = "*" + EntryDate;
                                MainNo = "*" + MainNo;
                                GoodsFinalName = "*" + GoodsFinalName + "(" + value.GoodsQty + ")";
                                CustAmt = "*" + CustAmt;
                                break;
                            case "R-":
                                PayConfirmDate = "@" + PayConfirmDate;
                                EntryDate = "@" + EntryDate;
                                MainNo = "@" + MainNo;
                                GoodsFinalName = "@" + GoodsFinalName + "(" + value.GoodsQty + ")";
                                CustAmt = "@" + CustAmt;
                                break;
                        }

                        asynTable += "<tr><td rowspan='2' style='text-align:center' class='rowColor_td'>" + (pageSize * (pageNo - 1) + i) + "</td>"; //번호
                        asynTable += "<td style='text-align:center' class='rowColor_td'>" + value.BillDate.split("T")[0] + "</td>";
                        asynTable += "<td style='text-align:center' class='rowColor_td' rowspan='2'>" + PayConfirmDate + "</td>";
                        asynTable += "<td style='text-align:center' class='rowColor_td'>" + EntryDate + "</td>";
                        asynTable += "<td style='text-align:center' class='rowColor_td' rowspan='2'>" + value.BuyComp_Name + "</td>";
                        asynTable += "<td style='text-align:center' class='rowColor_td' rowspan='2'>" + GoodsFinalName + "</td>";
                        asynTable += "<td style='text-align:center' class='rowColor_td'>" + value.GoodsModel + "</td>";
                        asynTable += "<td style='text-align:center' class='rowColor_td' rowspan='2'>" + CustAmt + "원</td>";
                        asynTable += "<td style='text-align:center' class='rowColor_td' rowspan='2'>" + numberWithCommas(value.SupplyJung) + "원</td>";
                        asynTable += "<td style='text-align:center' class='rowColor_td' rowspan='2'>" + numberWithCommas(value.DeliveryJung) + "원</td>";
                        asynTable += "<td style='text-align:center' class='rowColor_td' rowspan='2'>" + numberWithCommas(value.Billjung) + "원</td>";
                        asynTable += "<td style='text-align:center' class='rowColor_td' rowspan='2'>" + numberWithCommas(value.TotalJung) + "원</td>";
                        asynTable += "</tr>";

                        //--------------------------------------------------다음행-------------------------------------------------------------//
                        asynTable += "<tr>";
                        asynTable += "<td style='text-align:center' class='rowColor_td'>" + value.BillCodeNo + "</td>";
                        asynTable += "<td style='text-align:center' class='rowColor_td'>" + MainNo + "</td>";
                        asynTable += "<td style='text-align:center' class='rowColor_td'>" + value.GoodsUnitName + "</td>";

                        asynTable += "</tr>";
                        i++;

                    });
                } else {
                    asynTable += "<tr><td colspan='12' class='txt-center'>" + "리스트가 없습니다." + "</td></tr>"
                    $("#hdPopupTotalCount").val(0);
                }

                $("#tblPopup tbody").append(asynTable);
                fnCreatePagination('popupPagination', $("#hdPopupTotalCount").val(), pageNo, pageSize, getPopupPageData);
            };

            var param = {
                PayNo: hdPayNo
                , SvidCompCode: '<%=UserInfoObject.UserInfo.Company_Code%>'
                , Method: "BillHistoryInfo_A"
                , PageNo: pageNo
                , PageSize: pageSize
            };

            JajaxSessionCheck('Post', '../../Handler/PayHandler.ashx', param, 'json', callback, svidUser);
        }

        //페이징 인덱스 클릭시 속성데이터 바인딩
        function getPopupPageData() {
            var container = $('#popupPagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnPopupDataBind(getPageNum);
            return false;
        }

        function fnPopup(event) {

            var hdPayNo = $(event).find("#hdPayNo").val();
            var Amt = $(event).find("#hdAmt").val();
            $("#hdSelectPopPayNo").val(hdPayNo);
            $("#hdSelectPopAmt").val(Amt);

            fnPopupDataBind(1);

            var e = document.getElementById('divBillDetail');

            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }
        }

        function fnCancel() {
            $('.divpopup-layer-package').fadeOut();
        }

        //조회하기
        function fnSearch(pageNum) {
            var svidUser = '<%= Svid_User %>';
            var startDate = $('#<%= txtSearchSdate.ClientID%>').val();
            var endDate = $('#<%= txtSearchEdate.ClientID%>').val();
          <%-- var txtBuyCompName = $('#<%= txtBuyCompName.ClientID%>').val();--%>

           var pageSize = 20;
           var i = 1;
           var asynTable = "";

           var callback = function (response) {
               $("#tblProfitList tbody").empty();
               if (!isEmpty(response)) {
                   $.each(response, function (key, value) {
                       $("#hdTotalCount").val(value.TotalCount);

                       asynTable += "<tr><td rowspan='2' style='text-align:center' class='rowColor_td'><input id='hdPayNo' type='hidden' value='" + value.Unum_PayNo + "'>";
                       asynTable += "<input type='hidden' id='hdAmt' value='" + value.Amt + "' />" + (pageSize * (pageNum - 1) + i) + "</td>"; //번호
                       asynTable += "<td style='text-align:center' class='rowColor_td'>" + value.EntryDate.split("T")[0] + "</td>"; //세금계산서 발행일자
                       asynTable += "<td style='text-align:center' rowspan='2' class='rowColor_td'>" + value.GoodsFinalName + "</td>"; //세금계산서 발행정보
                       asynTable += "<td style='text-align:center' rowspan='2' class='rowColor_td'>" + numberWithCommas(value.Amt) + "원</td>"; //세금계산서 합계발행금액
                       asynTable += "<td style='text-align:center'>" + value.SbillSeq + "</td>"; //세금계산서 번호
                       asynTable += "<td style='text-align:center'>" + value.zSbillSeq + "</td>"; //면세계산서 번호
                       asynTable += "</tr>";

                       //--------------------------------------------------다음행-------------------------------------------------------------//
                       asynTable += "<tr>";
                       asynTable += "<td style='text-align:center' class='rowColor_td'>" + value.OrderCodeNo + "</td>";
                       asynTable += "<td style='text-align:center'>";
                       asynTable += "<input type='hidden' name='hdBillNo' value='" + value.SbillSeq + "' />"; //세금계산서 번호(과세)
                       asynTable += "<input type='hidden' name='hdMD5' value='" + value.MD5 + "' />"; //MD5(과세)
                       asynTable += "<input type='hidden' name='hdzBillNo' value='" + value.zSbillSeq + "' />"; //세금계산서 번호(면세)
                       asynTable += "<input type='hidden' name='hdzMD5' value='" + value.zMD5 + "' />"; //MD5(면세)
                       asynTable += "<img src= '' alt= '바로가기' onclick= 'fnBillPopup(this,1); return false;' id= 'img1' />" + "</td > "; //세금계산서상세(value.GoodsUnit)
                       asynTable += "<td style='text-align:center'><img src='' alt='바로가기' onclick='fnBillPopup(this,2); return false;' id='img2'/>" + "</td>"; //면세 세금계산서상세(value.PayWay)
                       asynTable += "</tr>";
                       i++;

                   });
               } else {
                   asynTable += "<tr><td colspan='6' class='txt-center'>" + "리스트가 없습니다." + "</td></tr>"
                   $("#hdTotalCount").val(0);
               }

               $("#tblProfitList tbody").append(asynTable);

               setTableHover();

               $("#tblProfitList tbody tr:even").on('click', 'td:not(:nth-child(6),:nth-child(7))', function () {
                   fnPopup($(this).parent());
               });


               $("#tblProfitList tbody tr:odd").on('click', 'td:not(:nth-child(2),:nth-child(3))', function () {
                   fnPopup($(this).parent().prev());
               });
               fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, 20, getPageData);
           };

           var param = {
               SvidUser: svidUser
               , ToDateB: startDate
               , ToDateE: endDate
               //, SaleCompName: txtBuyCompName
               , Method: "BillHistoryList_A"
               , PageNo: pageNum
               , PageSize: pageSize
           };

           JajaxSessionCheck('Post', '../../Handler/PayHandler.ashx', param, 'json', callback, svidUser);
        }

        //테이블 호버
        function setTableHover() {
            $("#tblProfitList tbody tr:even").each(function (index, element) {
                $(element).find(".rowColor_td").mouseover(function () {
                    $(element).find(".rowColor_td").css("background-color", "gainsboro");
                    $("#tblProfitList tbody tr:eq(" + (element.rowIndex - 1) + ")").find(".rowColor_td").css("background-color", "gainsboro");
                    //alert(element.rowIndex); //2 4 6
                    //alert(index); // 0 1 2              

                });
                $(element).find(".rowColor_td").mouseout(function () {
                    $(".rowColor_td").css("background-color", "");
                });
            });

            $("#tblProfitList tbody tr:odd").each(function (index, element) {
                $(element).find(".rowColor_td").mouseover(function () {
                    $(element).find(".rowColor_td").css("background-color", "gainsboro");
                    $("#tblProfitList tbody tr:eq(" + (index * 2) + ")").find(".rowColor_td").css("background-color", "gainsboro");
                    // alert(element.rowIndex); //3 5 7
                    // alert(index); // 0 1 2
                });
                $(element).find(".rowColor_td").mouseout(function () {
                    $(".rowColor_td").css("background-color", "");
                });
            });



        }

        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
            return false;
        }

        function fnEnter() {
            if (event.keyCode == 13) {
                fnSearch(1);
                return false;
            }
            else
                return true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <div class="all">
        <div class="sub-contents-div">
            <!--제목 타이틀-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    정산내역조회
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
          
            <!--탭메뉴-->
             <div class="div-main-tab" style="width: 100%; ">
                 <ul>
                    <li id="libs"  class='tabOff' style="width: 185px;">
                        <a>정산요약</a>
                    </li>
                    <li id="lipl" class='tabOff' style="width: 185px;">
                        <a>매출정산내역</a>
                    </li>
                    <li id="lirl" class='tabOff' style="width: 185px;">
                        <a>반품내역</a>
                    </li>
                    <li id="liob"  class='tabOn' style="width: 185px;">
                        <a>전자세금계산서 발행내역</a>
                    </li>
                    <li id="lipay"  class='tabOff' style="width: 185px;">
                        <a>대금정산</a>
                    </li>
                </ul>
            </div>
          <div class="tab-display1">
                <div class="tab" style="margin-top:10px">
                
                 <%--   <button class="tabButton1" type="button" id="btnTab1" onclick="javascript:location.href='OrderBillIssue.aspx';"><img src="" alt="발행" /></button>
                    <button class="tabButton2" type="button" id="btnTab2" onclick="javascript:location.href='OrderBillIssueCheck.aspx';"><img src="" alt="확인"/></button>
              --%>
               <input type="button" value="발행 조회" style="width:75px; height:30px" class="mainbtn type1"  id="btnTab1" onclick="javascript:location.href='OrderBillIssue.aspx?ucode=' + ucode;"/>
                    <input type="button" value="확인 조회" style="width:75px; height:30px" class="mainbtn type2"  id="btnTab2" onclick="javascript:location.href='OrderBillIssueCheck.aspx?ucode=' + ucode;"/>
                </div>
            </div>

            <!--상단영역 시작-->
            <div class="search-div">
                <table id="tblSearch">
                    <thead>
                        <tr>
                            <th colspan="12" style="height: 40px;">전자 세금계산서 내역확인</th>
                        </tr>
                    </thead>


                    <tr>
                        <th rowspan="2" style="width: 130px;">세금계산서 발행일자</th>
                        <td rowspan="2" style="text-align: left; padding-left: 5px; width:350px" >
                            <asp:TextBox ID="txtSearchSdate" runat="server" CssClass="calendar" ReadOnly="true" Height="24px"></asp:TextBox>&nbsp;&nbsp;
                            -
                            &nbsp;&nbsp;<asp:TextBox ID="txtSearchEdate" runat="server" CssClass="calendar" ReadOnly="true" Height="24px"></asp:TextBox>&nbsp;&nbsp;
                            <input type="button" class="mainbtn type1" value="조회하기" style="width:95px; height:30px" onclick="fnSearch(1); return false;"/>
                        </td> 
                       <%-- <th style="width: 130px;">구매사</th>
                        <td style="width: 200px;">
                            <asp:TextBox ID="txtBuyCompName" runat="server" Height="100%" OnKeypress="return fnEnter();" Width="98%" Style="border: 1px solid #a2a2a2;"></asp:TextBox>
                        </td>
                        <td style="width:100px">
                             <img alt="조회하기" src="../../Images/Goods/aslist.jpg" id="btnSearch" onmouseover="this.src='../../Images/Wish/aslist-over.jpg'" onmouseout="this.src='../../Images/Goods/aslist.jpg'" onclick="fnSearch(1);return false;"/>
                        </td>--%>
                    </tr>

                </table>
            </div>
            <!--상단영역 끝-->

            <br />

            <!--하단영역시작-->
            <div class="orderList-div" style="width: 100%;">
                <%--  <table  id="tblorderList" style="border:1px solid #a2a2a2;width:2850px;height:40px;">--%>
                <table id="tblProfitList" style="width: 100%">
                    <thead>
                        <tr>
                            <th class="text-center" style="width: 30px" rowspan="2">번호</th>
                            <th class="text-center" style="width: 100px">세금계산서 발행일자</th>
                            <th class="text-center" style="width: 120px" rowspan="2">세금계산서 발행정보</th>
                            <th class="text-center" style="width: 120px" rowspan="2">세금계산서<br />합계 발행 금액</th>
                            <th class="text-center" style="width: 120px">세금계산서 번호</th>
                            <th class="text-center" style="width: 120px">[면세]<br />
                                세금계산서 번호</th>
                        </tr>
                        <tr>
                            <th class="text-center" style="width: 100px">세금계산서 발행번호</th>
                            <th class="text-center" style="width: 120px">세금계산서 상세</th>
                            <th class="text-center" style="width: 120px">[면세]<br />
                                세금계산서 상세</th>
                        </tr>
                    </thead>
                    <tbody id="tbodyList">
                        <tr>
                            <td class="text-center" colspan="6">리스트가 없습니다.</td>                     
                        </tr>     
                    </tbody>
                </table>
                <br />
                  <input type="hidden" id="hdTotalCount"/>

                <!-- 페이징 처리 -->   
                <div style="margin:0 auto; text-align:center">
                    <div id="pagination" class="page_curl" style="display:inline-block"></div> 
                </div>
     
            </div>

            <!--하단영역끝-->

        </div>

        <%--전자세금계산서 팝업 시작--%>
        <div id="divBillDetail" class="divpopup-layer-package">

            <div class="billDetailWrapper">
                <div class="billDetailContent" style="border: none; height:750px;">

                    <div class="sub-title-div">
                        <img src="" alt="세금계산서 발행정보"/>
                    </div>

                    <div class="tblBillDetail-div" style="height: auto; width: 100%; overflow-x: scroll; ">
                        <table id="tblPopup" style="width:1024px">
                            <thead>
                                <tr>
                                    <th style="width: 20px;" rowspan="2">번호
                                        <input type="hidden" id="hdSelectPopPayNo" value="" />
                                        <input type="hidden" id="hdSelectPopAmt" value="" />
                                    </th>
                                    <th style="width: 70px;">세금계산서 발행일자</th>
                                    <th style="width: 60px;" rowspan="2">*주문입금날짜<br />#A/S입금날짜<br />@반품출금날짜</th>
                                    <th style="width: 60px;">*주문일자<br />#A/S일자<br />@반품일자</th>
                                    <th style="width: 70px;" rowspan="2">구매사</th>
                                    <th style="width: 90px;" rowspan="2">*주문상품명(수량)<br />#A/S상품정보(수량)<br />@반품상품정보(수량)</th>
                                    <th style="width: 50px;">모델명</th>
                                    <th style="width: 70px;" rowspan="2">*판매사 매출정산<br />#A/S매출정산<br />@판매사반품정산</th>
                                    <th style="width: 50px;" rowspan="2">플랫폼<br />이용수수료</th>
                                    <th style="width: 50px;" rowspan="2">배송비<br />수수료</th>
                                    <th style="width: 50px;" rowspan="2">세금계산서<br />수수료</th>
                                    <th style="width: 50px;" rowspan="2">세금계산서<br />발행금액</th>
                                    
                                </tr>
                                <tr>
                                    <th>세금계산서 발행번호</th>
                                    <th>*주문번호<br />#A/S번호<br />@반품번호</th>
                                    <th>내용량</th>                                    
                                </tr>
                            </thead>
                            <tbody id="tbody_pop_odrDtl">
                                <tr>
                                    <td class="text-center" colspan="12">리스트가 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                           
                    </div>

               
                    <div style="float: right;">
                        <span>※ 세금계산서 합계 발행금액 : </span><label id="lblTotCost"></label>

                    </div> 
                    <br />
                    <br />
                     <!--페이징-->
                            <input type="hidden" id="hdPopupTotalCount" />
                            <div  style="margin:0 auto; text-align:center">
                                <div id="popupPagination" class="page_curl" style="display:inline-block"></div>
                            </div>
                    <br />
                    <br />
         
                    <a style="float: right;">
                        <img src="../../Images/Goods/sub-off.jpg" alt="확인" onclick="fnCancel('divPopup')" onmouseover="this.src='../../Images/Goods/sub-on.jpg'" onmouseout="this.src='../../Images/Goods/sub-off.jpg'" /></a>
                    
                </div>
            </div>
        </div>

    </div>
</asp:Content>

