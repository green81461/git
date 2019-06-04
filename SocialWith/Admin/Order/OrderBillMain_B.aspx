<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OrderBillMain_B.aspx.cs" Inherits="Admin_Order_OrderBillMain_B" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <script src="../../Scripts/jquery.inputmask.bundle.js"></script>

    <script>
        var is_sending = false;

        $(document).ready(function () {
            $("#<%=this.txtSearchSdate.ClientID%>").inputmask("9999-99-99");
            $("#<%=this.txtSearchEdate.ClientID%>").inputmask("9999-99-99");
            //체크박스 하나만 선택
            var tableid = 'tblHistoryList';
            ListCheckboxOnlyOne(tableid);

            //달력
            $("#<%=this.txtSearchSdate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true,
                onSelect: function (dateText, inst) {         //달력에 변경이 생길 시 수행하는 함수. 
                    SetDate();
                }

            });

            $("#<%=this.txtSearchEdate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });

            $('#tblHistoryList input[type="checkbox"]').change(function () {
                if ($(this).prop('checked') == true) {
                    var num = $(this).val();
                    if (num == '0') {
                        $("#<%=this.txtSearchSdate.ClientID%>").val('')
                        $("#<%=this.txtSearchEdate.ClientID%>").val('')
                        $("#<%=this.txtSearchSdate.ClientID%>").attr("readonly", false)      //ReadOnly 풀기
                        $("#<%=this.txtSearchEdate.ClientID%>").attr("readonly", false)      //ReadOnly 풀기 
                        // $("input[name=id]").attr("readonly", true);
                        return;
                    }
                    else {
                        $("#<%=this.txtSearchSdate.ClientID%>").attr("readonly", true)      //ReadOnly 적용
                        $("#<%=this.txtSearchEdate.ClientID%>").attr("readonly", true)      //ReadOnly 적용 
                    }

                    var resultSDate = new Date();
                    var resultEDate = new Date();
                    $("#<%=this.txtSearchEdate.ClientID%>").val($.datepicker.formatDate("yy-mm-dd", resultEDate));
                    var newDate = new Date($("#<%=this.txtSearchEdate.ClientID%>").val());

                    resultSDate.setDate(newDate.getDate() - num);
                    $("#<%=this.txtSearchSdate.ClientID%>").val($.datepicker.formatDate("yy-mm-dd", resultSDate));
                }
            });

            fnSearch(1); //조회하기

            /*
             * 20190315
             * 세금계산서 발행 팝업 관련
            */

            // 세금계산서 팝업
            //$("#tbodyBill").on("click", "a", fnSelectPopOpen);

            $('#divPopBtn').on("click", function (e) {
                e.preventDefault();

                var target = e.target;
                var targetIdName = $(target).prop("id");
                var selOrderCodeNo = $("#hdPopOrdCodeNo").val();

                switch (targetIdName) {
                    case "btnTaxBillPrint":
                        var confirmVal = confirm("정말로 세금계산서를 발행하시겠습니까?");

                        if (confirmVal) {
                            fnPopDataUpdate(e, selOrderCodeNo);
                        }
                        break;
                    case "btnPopClose":
                        fnPopClose(e);
                        break;
                }

            });

        });

        function SetDate() {

            $("input[name=chkBox]:checked").each(function () {
                var num = $(this).val();                 //선택한 체크박스
                var newEDate = new Date($("#<%=this.txtSearchSdate.ClientID%>").val());         //시작일자를 NewEDate에 넣음

                var resultDate = new Date();
                num = parseInt(num);
                resultDate.setDate(newEDate.getDate() + num);             //ResultDate에 일자를 NewEdate의 일자로 넣고 선택한 체크박스만큼 더한다.

                if (newEDate.getFullYear() != resultDate.getFullYear()) {         //연도가 다를 때
                    resultDate.setFullYear(newEDate.getFullYear());               //연도를 세팅해준다.
                }

                //if (newEDate.getMonth() == '11' && newEDate.getDate() + num >= 31) {     //12월이며 날짜 값이 31이 넘을 때
                //    alert('1')
                //    resultDate.setFullYear(newEDate.getFullYear() + 1);             //연도 세팅
                //}

                //if (newEDate.getMonth() == '9' && newEDate.getDate()>= 3 && num == 90) {     //12월이며 날짜 값이 31이 넘을 때
                //    alert('10월..')
                //    resultDate.setFullYear(newEDate.getFullYear() + 1);             //연도 세팅

                //}



                var lastDay = (new Date(newEDate.getFullYear(), newEDate.getMonth() + 1, 0)).getDate();        //그 달의 마지막 날 구하는 방법


                if (newEDate.getMonth() == resultDate.getMonth()) {       //newEDate의 달과 ResultDate의 달이 같을 때 처리

                    if (newEDate.getMonth() == '9' && newEDate.getDate() >= 3) { //10월 3일~10월31일 처리과정.
                        resultDate.setMonth(resultDate.getMonth() + 3);
                    }
                }
                else {   //같지 않을때, 달을 바꿔 맞춰준다.
                    resultDate.setMonth(newEDate.getMonth());            //ResultDate에 달 값을 NewEdate의 달로 세팅함.

                    if (num == '1' && newEDate.getDate() >= lastDay) {           //마지막날 비교 후 달 변경
                        resultDate.setMonth(newEDate.getMonth() + 1);  //1일 선택 시
                    }
                    else if (num == '7' && newEDate.getDate() >= '24') { //7일 선택 시
                        resultDate.setMonth(newEDate.getMonth() + 1);
                    }
                    else if (num == '15' && newEDate.getDate() >= '17') { //15일 선택 시
                        resultDate.setMonth(newEDate.getMonth() + 1);
                    }
                    else if (num == '30' && newEDate.getDate() >= '2') { //30일 선택 시
                        resultDate.setMonth(newEDate.getMonth() + 1);
                    }
                    else if (num == '90') {  //90일 선택 시 
                        resultDate.setDate(newEDate.getDate() + num);
                    }

                }
                $("#<%=this.txtSearchEdate.ClientID%>").val($.datepicker.formatDate("yy-mm-dd", resultDate));

            });

        }
        //조회하기
        function fnSearch(pageNum) {
            var startDate = $('#<%= txtSearchSdate.ClientID%>').val();
            var endDate = $('#<%= txtSearchEdate.ClientID%>').val();
            var buyCompNm = $('#<%= txtBuyCompName.ClientID%>').val();
            var saleCompNm = $('#<%= txtSaleCompName.ClientID%>').val();
            var pageSize = 20;
            var asynTable = "";

            var callback = function (response) {

                $("#tbodyBill").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {

                        if (key == 0) $('#hdTotalCount').val(value.TotalCount);

                        var compDeptNm = value.CompanyDeptName;
                        var budgetAccoNm = value.BudgetAccountName;
                        if (isEmpty(budgetAccoNm)) compDeptNm = '';

                        asynTable += "<tr>";
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.RowNumber + "</td>";
                        asynTable += "<td class='txt-center'>" + fnOracleDateFormatConverter(value.EntryDate) + "</td>";
                        asynTable += "<td class='txt-center'>" + value.BuyCompany_Name + "</td>";
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.OrderSaleCompanyName + "</td>";
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.GoodsFinalName + "</td>";
                        asynTable += "<td rowspan='2' class='txt-center'>" + numberWithCommas(value.GoodsSalePriceVat) + "원" + "</td>";

                        var OrdStatusIcon = '<img src="../Images/Order/ico_OrdStatus_' + value.OrderStatus + '.png"/>'; //주문상태아이콘
                        
                        //asynTable += "<td class='txt-center'>" + value.OrderStatus_NAME + "</td>";
                        asynTable += "<td class='txt-center'>" + OrdStatusIcon + "</td>";
                        asynTable += "<td class='txt-center'>" + value.BillNo + "</td>";
                        asynTable += "<td class='txt-center'>" + value.zBillNo + "</td>";

                        var billNo = value.BillNo;
                        var zBillNo = value.zBillNo;
                        var MD5 = value.MD5;
                        var zMD5 = value.zMD5;
                        var tdMD5Bill = '';
                        var tdZMD5Bill = '';

                        var imgBillSrc = "../Images/Order/ico_OrderBill_B.png";
                        var onClickBtnFn = "fnSelectPopOpen(event)";

                        if (isEmpty(billNo) || isEmpty(MD5)) {
                            imgBillSrc = "../Images/Order/ico_OrderBill_B.png";
                            onClickBtnFn = "fnSelectPopOpen(event)";

                        } else {
                            imgBillSrc = "../Images/Order/ico_OrderBillModify_B.png";
                            onClickBtnFn = "javascript:alert(\"준비중입니다.\"); return false;";
                        }

                        //onClickBtnFn = "fnSelectPopOpen(event)";

                        //asynTable += "<td rowspan='2'><a href='#none' class='btnTaxBill''>세금계산서 발행</a></td>";
                        asynTable += "<td rowspan='2'><img src='" + imgBillSrc + "' onclick='"+onClickBtnFn+"' /></td>";

                        asynTable += "</tr>";
                        //------------------------------------------------------------------------------
                        asynTable += "<tr>";

                        asynTable += "<td id='OrderCodeNo' class='txt-center'>" + value.OrderCodeNo;
                        asynTable += "<input type='hidden' id='orderCodeNo' value='" + value.OrderCodeNo + "' />";
                        asynTable += "<input type='hidden' class='orderStatus' value='" + value.OrderStatus + "'/>";
                        asynTable += "<input type='hidden' class='billTransCnt' value='" + value.BillTransCnt + "' /></td > ";
                        
                        asynTable += "<td class='txt-center'>" + value.Name + "</td>";

                        var PaywayIcon = '<img src="../Images/Order/ico_PayWay_' + value.PayWay + '.png"/>'; //결제방법아이콘

                        //asynTable += "<td class='txt-center'>" + value.PayWay + "</td>";
                        asynTable += "<td class='txt-center'>" + PaywayIcon + "</td>";

                        

                        //과세
                        if (isEmpty(billNo) || isEmpty(MD5)) {
                            tdMD5Bill = "<span style='color:red;'>진행중</span>";

                        } else {
                            tdMD5Bill = "<a onClick='fnBillDirect(this, \"MD5\")'><input type='hidden' id='hdMD5' value='" + MD5 + "'/><input type='hidden' id='hdbillNo' value='" + billNo + "'/>"
                                + "<img src='../Images/Order/goDirect-on.jpg' alt='바로가기' onmouseover=\"this.src='../Images/Order/goDirect-off.jpg'\" onmouseout=\"this.src='../Images/Order/goDirect-on.jpg'\"></a>";
                        }
                        //면세
                        if (!isEmpty(zBillNo) && !isEmpty(zMD5)) {
                            tdZMD5Bill = "<a onClick='fnBillDirect(this, \"ZMD5\")'><input type='hidden' id='hdZMD5' value='" + zMD5 + "'/><input type='hidden' id='hdZBillNo' value='" + zBillNo + "'/>"
                                + "<img src='../Images/Order/goDirect-on.jpg' alt='바로가기' onmouseover=\"this.src='../Images/Order/goDirect-off.jpg'\" onmouseout=\"this.src='../Images/Order/goDirect-on.jpg'\"></a>";
                        }

                        asynTable += "<td class='txt-center'>" + tdMD5Bill + "</td>";
                        asynTable += "<td class='txt-center'>" + tdZMD5Bill + "</td>";
                        asynTable += "</tr>";

                    });

                } else {
                    asynTable += "<tr><td colspan='10' class='txt-center'>" + "리스트가 없습니다." + "</td></tr>";
                }

                $("#tbodyBill").append(asynTable);

                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, pageSize, getPageData);
            }

            var param = { SvidUser: '<%= Svid_User%>', TodateB: startDate, TodateE: endDate, BuyCompNm: buyCompNm, SaleCompNm: saleCompNm, PageNo: pageNum, PageSize: pageSize, Method: 'OrderBillIssue_Admin' };
            JajaxSessionCheck('Post', '../../Handler/OrderHandler.ashx', param, 'json', callback, '<%= Svid_User%>');
        }
        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
            return false; hdTotalCount
        }

        //바로가기
        function fnBillDirect(el, billFlag) {
            var billNo = $(el).find("#hdbillNo").val();
            var zBillNo = $(el).find("#hdZBillNo").val();
            var MD5 = $(el).find("#hdMD5").val();
            var zMD5 = $(el).find("#hdZMD5").val();
            var url = '';

            if (billFlag == "MD5") url = "http://www.sendbill.co.kr/PreView?seq=" + billNo + "&cert=" + MD5 + "&VenderCheck=N&PR_DIV=R";
            if (billFlag == "ZMD5") url = 'http://www.sendbill.co.kr/PreView?seq=' + zBillNo + "&cert=" + zMD5 + "&VenderCheck=N&PR_DIV=R";

            var width = 800;
            var height = 500;
            var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
            var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

            var getwidth = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
            var getheight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

            var left = ((getwidth / 2) - (width / 2)) + dualScreenLeft;
            var top = ((getheight / 2) - (height / 2)) + dualScreenTop;

            window.open(url, '', "width=" + width + ",height=" + height + ",status=no ,toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes,left=" + left + ", top=" + top + "");

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

        function fnEnterDate() {

            if (event.keyCode == 13) {

                argStr1 = $("#<%=this.txtSearchSdate.ClientID%>").val();
                argStr2 = $("#<%=this.txtSearchEdate.ClientID%>").val();
                AutoDateSet(argStr1, argStr2)
                return false;
            }
            else
                return true;
        }

        //날짜 데이터 하이픈 넣기
        function AutoDateSet(argStr1, argStr2) {
            var retVal1;
            var retVal2;

            if (argStr1 !== undefined && String(argStr1) !== '') {

                var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;

                var tmp = String(argStr1).replace(/(^\s*)|(\s*$)/gi, '').replace(regExp, ''); // 공백 및 특수문자 제거

                if (tmp.length <= 4) {

                    retVal1 = tmp;

                } else if (tmp.length > 4 && tmp.length <= 6) {

                    retVal1 = tmp.substr(0, 4) + '-' + tmp.substr(4, 2);

                } else if (tmp.length > 6 && tmp.length <= 8) {

                    retVal1 = tmp.substr(0, 4) + '-' + tmp.substr(4, 2) + '-' + tmp.substr(6, 2);

                } else {

                    alert('날짜 형식이 잘못되었습니다.\n입력된 데이터:' + tmp);

                    retVal1 = '';

                }

            }

            if (argStr2 !== undefined && String(argStr2) !== '') {
                var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;

                var tmp2 = String(argStr2).replace(/(^\s*)|(\s*$)/gi, '').replace(regExp, ''); // 공백 및 특수문자 제거

                if (tmp2.length <= 4) {

                    retVal2 = tmp2;

                } else if (tmp2.length > 4 && tmp2.length <= 6) {

                    retVal2 = tmp2.substr(0, 4) + '-' + tmp2.substr(4, 2);

                } else if (tmp2.length > 6 && tmp2.length <= 8) {

                    retVal2 = tmp2.substr(0, 4) + '-' + tmp2.substr(4, 2) + '-' + tmp2.substr(6, 2);

                } else {

                    alert('날짜 형식이 잘못되었습니다.\n입력된 데이터:' + tmp2);

                    retVal2 = '';

                }

            }

            $("#<%=this.txtSearchSdate.ClientID%>").val(retVal1);
            $("#<%=this.txtSearchEdate.ClientID%>").val(retVal2);
            return retVal1, retVal2;
        }

        function fnSelectPopOpen(e) {
            
            var target = e.target;
            var selectTr = $(target).parents('tr').next('tr');
            var selectTd = $(selectTr).find('td#OrderCodeNo');
            var selOrderCodeNo = $(selectTd).find('input[type=hidden]#orderCodeNo').val();
            var OrderStatus = $(selectTd).find('input[type=hidden].orderStatus').val();
            var billTransCnt = $(selectTd).find('input[type=hidden].billTransCnt').val();
            
            if (OrderStatus == "302") {
            
                if (billTransCnt > 0) {
                    fnSetDetailPopupDataBind(selOrderCodeNo);
                } else{
                    var confirmVal = confirm("세금계산서를 등록하시겠습니까?");

                    if (confirmVal) {
                        fnSetDetailPopupDataBind(selOrderCodeNo);
                    } else {
                        return false;
                    }
                }
                
            } else {
                if (!isEmpty(selOrderCodeNo)) {
                    alert("[" + selOrderCodeNo + "] 주문번호에 해당되는 상품들이 전부 배송완료되어야 확인이 가능합니다. 배송완료 상태로 변경하시기 바랍니다.");
                }
                
                return false;
            }

        }
        
        function fnSetDetailPopupDataBind(selOrderCodeNo) {
            var callback = function (response) {
                if (!isEmpty(response)) {
                    fnSetTaxBillData(response, selOrderCodeNo);
                }
                return false;
            }

            // 팝업 - 작성일자 datepicker
            $("#txt_DT").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                buttonImageOnly: false,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true,
                onSelect: function (dateText, inst) { 
                    $('#sp_tradeDt').text($('#txt_DT').val());
                    SetDate();
                }
            });

            var param = {
                OrdCodeNo: selOrderCodeNo,
                Method: 'InsertOrderBill_B_Admin'
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            if (is_sending) return false;

            JqueryAjax("Post", "./../../Handler/OrderHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        // 취소 버튼 클릭 시 팝업 닫기
        function fnPopClose() {
            $("#popTaxWrap").fadeOut();
        }

        function fnPopDataUpdate(e, selOrderCodeNo) {
            var callback = function (response) {
                if (!isEmpty(response)) {
                    alert("성공적으로 세금계산서가 발행되었습니다.");
                    fnSetTaxBillData(response, selOrderCodeNo);
                } else {
                    alert("세금계산서 발행에 실패하였습니다. 개발담당자에게 문의바랍니다.");
                }
                return false;
            }
            
            var param = {
                OrdCodeNo: selOrderCodeNo,
                Scompany: $('#txt_sCompany').val(),
                Rcompany: $('#txt_rCompany').val(),
                Dt: $('#txt_DT').val(),
                Obj: $('#txt_Obj').val(),
                Suser: $('#txt_sUser').val(),
                Ruser: $('#txt_rUser').val(),
                Sdivision: $('#txt_sDivision').val(),
                Rdivision: $('#txt_rDivision').val(),
                STelNo: $('#txt_sTelNo').val(),
                RTelNo: $('#txt_rTelNo').val(),
                SEmail: $('#txt_sEmail').val(),
                REmail: $('#txt_rEmail').val(),
                Method: 'UpdateOrderBill_B_Admin'
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            if (is_sending) return false;

            JqueryAjax("Post", "./../../Handler/OrderHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        function fnSetTaxBillData(response, selOrderCodeNo) {
            /* S. 세금계산서(공급자 보관용) */
            var sCode = response.SvenderNo;             // 공급자 - 사업자번호
            var sCompany = response.Scompany;           // 공급자 - 상호(법인명)
            var sName = response.SceoName;              // 공급자 - 성명(대표자)
            var sAddress = response.Saddress;           // 공급자 - 사업자주소
            var sUptae = response.Suptae;               // 공급자 - 업태
            var sUpjong = response.Supjong;             // 공급자 - 업종
            var rCode = response.RvenderNo;          // 공급받는자 - 사업자번호 
            var rCompany = response.Rcompany;              // 공급받는자 - 상호(법인명)
            var rName = response.RceoName;              // 공급받는자 - 성명(대표자)
            var rAddress = response.Raddress;           // 공급받는자 - 사업자주소
            var rUptae = response.Ruptae;               // 공급받는자 - 업태
            var rUpjong = response.Rupjong;             // 공급받는자 - 업종

            $("#hdPopOrdCodeNo").val(selOrderCodeNo);

            $('#sp_OrdCode').text(selOrderCodeNo);
            $('#sp_sCode').text(sCode);
            $('#txt_sCompany').val(sCompany);
            $('#sp_sCeoName').text(sName);
            $('#sp_sAddress').text(sAddress);
            $('#sp_sUptae').text(sUptae);
            $('#sp_sUpjong').text(sUpjong);

            $('#sp_rCode').text(rCode);
            $('#txt_rCompany').val(rCompany);
            $('#sp_rCeoName').text(rName);
            $('#sp_rAddress').text(rAddress);
            $('#sp_rUptae').text(rUptae);
            $('#sp_rUpjong').text(rUpjong);

            /*=====================================================================*/
                    
            var createDate = response.Dt;               // 작성일자
            var sUpMoney = response.SupMoney;           // 공급가액
            var taxMoney = response.TaxMoney;           // 세액
            var tradeDate = response.ItemDt;            // 거래일자
            var tradeObj = response.Obj;                // 품목
            var totalMoney = response.SupMoney + response.TaxMoney; // 합계금액

            $('#txt_DT').val(createDate);
            $('#sp_sUpMoney').text(numberWithCommas(sUpMoney));
            $('#sp_taxMoney').text(numberWithCommas(taxMoney));
            $('#sp_tradeDt').text(tradeDate)
            $('#txt_Obj').val(tradeObj);
            $('#sp_totalMoney').text(numberWithCommas(totalMoney));

            /* S. 담당자 정보 */
            var sUser = response.Suser;
            var sDivision = response.Sdivision;
            var sTelNo = response.StelNo;
            var sEmail = response.Semail;
            var rUSer = response.Ruser;
            var rDivision = response.Rdivision;
            var rTelNo = response.RtelNo;
            var rEmail = response.Remail;

            $('#txt_sUser').val(sUser);
            $('#txt_sDivision').val(sDivision);
            $('#txt_sTelNo').val(sTelNo);
            $('#txt_sEmail').val(sEmail);
            $('#txt_rUser').val(rUSer);
            $('#txt_rDivision').val(rDivision);
            $('#txt_rTelNo').val(rTelNo);
            $('#txt_rEmail').val(rEmail);

            var popDiv = $("#popTaxWrap");
            if (popDiv.css("display") != "block") {
                fnOpenDivLayerPopup("popTaxWrap");
            } else {
                fnOpenDivLayerPopup("popTaxWrap");
            }
        }
    </script>
    <style>
        .tbl_popup td input[type="text"]{display:block; width:100%; padding:0 5px}
        .tbl_popup{width:100%; border:1px solid #444; table-layout:fixed}
        .tbl_popup th,
        .tbl_popup td,
        .tbl_popup tr th,
        .tbl_popup tr td{padding:5px; border-right:1px solid #444}
        .tbl_popup tr{border-bottom:1px solid #444}
        .tbl_popup tbody tr:last-child{border-bottom:0}

        .tbl_popup + .tbl_popup{border-top:0}

        .tbl_popup tr th{background-color:#ffe8e6}
        .tbl_popup tr th.bgColor{background-color:#eebfb9}

    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="sub-contents-div">

        <div class="sub-title-div">
            <p class="p-title-mainsentence">
                전자세금계산서 발행현황
                <span class="span-title-subsentence"></span>
            </p>
        </div>
        <!--탭영역-->
        <div class="div-main-tab" style="width: 100%;">
             <ul>
                <li class="tabOn" style="width: 185px;" onclick="fnTabClickRedirect('OrderBillMain_B');">
                    <a onclick="fnTabClickRedirect('CategoryManage');">최종현황</a>
                </li>
                <li class="tabOff" style="width: 185px;" onclick="fnTabClickRedirect('OrderBillIssue_B');">
                    <a onclick="fnTabClickRedirect('CategoryRegister');">이슈현황</a>
                </li>
            </ul>
        </div>
        <div class="search-div">
            <table id="tblHistoryList" class="tbl_main">
                <colgroup>
                    <col style="width:200px;"/>
                    <col />
                    <col style="width:200px;"/>
                    <col />
                </colgroup>
                <tr>
                    <th>조회기간</th>
                    <td colspan="3">
                        <asp:TextBox ID="txtSearchSdate" runat="server" MaxLength="10" CssClass="calendar" onkeypress="return fnEnterDate();" placeholder="2018-01-01" ReadOnly="true"></asp:TextBox>
                        -
                            <asp:TextBox ID="txtSearchEdate" runat="server" MaxLength="10" CssClass="calendar" onkeypress="return fnEnterDate();" placeholder="2018-12-30" ReadOnly="true"></asp:TextBox>
                        &nbsp;&nbsp;&nbsp;
                            <input type="checkbox" name="chkBox" id="ckbSearch1" value="1" checked="checked" /><label for="ckbSearch1">1일</label>
                        <input type="checkbox" name="chkBox" id="ckbSearch2" value="7" /><label for="ckbSearch2">7일</label>
                        <input type="checkbox" name="chkBox" id="ckbSearch3" value="15" /><label for="ckbSearch3">15일</label>
                        <input type="checkbox" name="chkBox" id="ckbSearch4" value="30" /><label for="ckbSearch4">30일</label>
                        <input type="checkbox" name="chkBox" id="ckbSearch5" value="90" /><label for="ckbSearch5">90일</label>
                        <input type="checkbox" name="chkBox" id="ckbSearch6" value="0" /><label for="ckbSearch6">직접입력</label>
                    </td>
                </tr>
                <tr>
                    <th>판매사</th>
                    <td>
                        <asp:TextBox runat="server" ID="txtSaleCompName" class="medium-size" Onkeypress="return fnEnter();"></asp:TextBox>
                    </td>
                    <th>구매사</th>
                    <td >
                        <asp:TextBox runat="server" ID="txtBuyCompName" class="medium-size" Onkeypress="return fnEnter();"></asp:TextBox>
                    </td>
                </tr>
            </table>

            <!--조회하기버튼영역-->
            <div class="align-div" style="text-align: right; margin-top: 10px; margin-bottom: 10px;">
                <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="검색" onclick="fnSearch(1); return false;" />
            </div>
        </div>
        <span style="color: #69686d; float: right; margin-top: 10px; margin-bottom: 10px;">*<b style="color: #ec2029; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</span>

        <div style="margin-top: 30px;">
            <table id="tblSearch" class="tbl_main">
                <colgroup>
                    <col width="4%" />
                    <col width="10%" />
                    <col width="8%" />
                    <col width="8%" />
                    <col width="17%" />
                    <col width="8%" />
                    <col width="10%" />
                    <col width="10%" />
                    <col width="10%" />
                    <col width="15%" />
                </colgroup>
                <thead>
                    <tr>
                        <th rowspan="2">번호</th>
                        <th>주문일자</th>
                        <th>구매사</th>
                        <th rowspan="2">판매사</th>
                        <th rowspan="2">주문상품정보</th>
                        <th rowspan="2">구매가격</th>
                        <th class="auto-style2">주문처리현황</th>
                        <th class="auto-style2">세금계산서번호</th>
                        <th class="auto-style2">[면세]<br>계산서번호</th>
                        <th class="auto-style2" rowspan="2">세금계산서 구분</th>
                    </tr>
                    <tr>
                        <th>주문번호</th>
                        <th>주문자</th>
                        <th class="text-center">결제수단</th>
                        <th class="text-center">세금계산서상세</th>
                        <th class="text-center">계산서상세</th>
                    </tr>
                </thead>
                <tbody id="tbodyBill">
                
                </tbody>
            </table>
        </div>
        <input type="hidden" id="hdTotalCount" />
        <!-- 페이징 처리 -->
        <div class="page_wrap">
            <div id="pagination" class="page_curl" style="display: inline-block"></div>
        </div>
        <!--이슈현황 엑셀저장 버튼-->
        <div class="align-div" style="text-align: right; margin-top: 10px; margin-bottom: 10px;">
            <input type="submit" class="mainbtn type1" value="이슈현황 엑셀저장"/>
        </div>
    </div>

    <!-- S. 세금계산서 팝업 -->
        <div id="popTaxWrap" class="popupdiv divpopup-layer-package">
            <div class="popupdivWrapper" style="width:80%">
                <div class="popupdivContents">
                <!-- S. 팝업 제목 -->
                    <div class="sub-title-div" style="padding:0 10px; background-color:#d92b2b">
                        <h3 class="pop-title" style="margin-top:10px; color:#fff; ">세금계산서 발행(<span id="sp_OrdCode"></span>)</h3>
                    </div>
                <!-- E. 팝업 제목 -->

                <!-- S. 팝업 내용 -->
                    <h4 style="padding:0 10px;">세금계산서(공급자 보관용)</h4>
                    <div class="tblOrder-div">
                        <table id="tblTaxPrintType0" class="tbl_popup pop_tblType0">
                            <colgroup>
                                <col width="8%"" />
                                <col width="10%"" />
                                <col width="32%" />
                                <col width="8%"" />
                                <col width="10%"" />
                                <col width="32%" />
                            </colgroup>
                            <tr>
                                <th rowspan="6" class="text-center bgColor">공급자</th>
                                <th class="text-center">사업자번호</th>
                                <td><span id="sp_sCode"></span></td>
                                <th rowspan="6" class="text-center bgColor">공급받는자</th>
                                <th class="text-center">사업자번호</th>
                                <td><span id="sp_rCode"></span></td>
                            </tr>
                            <tr>
                                <th class="text-center">상호(법인명)</th>
                                <td><input type="text" id="txt_sCompany" value="" /></td>
                                <th class="text-center">상호(법인명)</th>
                                <td><input type="text" id="txt_rCompany" value="" /></td>
                            </tr>
                            <tr>
                                <th class="text-center">성명(대표자)</th>
                                <td><span id="sp_sCeoName"></span></td>
                                <th class="text-center">성명(대표자)</th>
                                <td><span id="sp_rCeoName"></span></td>
                            </tr>
                            <tr>
                                <th class="text-center">사업자 주소</th>
                                <td><span id="sp_sAddress"></span></td>
                                <th class="text-center">사업자 주소</th>
                                <td><span id="sp_rAddress"></span></td>
                            </tr>
                            <tr>
                                <th class="text-center">업태</th>
                                <td><span id="sp_sUptae"></span></td>
                                <th class="text-center">업태</th>
                                <td><span id="sp_rUptae"></span></td>
                            </tr>
                            <tr>
                                <th class="text-center">업종</th>
                                <td><span id="sp_sUpjong"></span></td>
                                <th class="text-center">업종</th>
                                <td><span id="sp_rUpjong"></span></td>
                            </tr>
                        </table>
                        <table id="tblTaxPrintType1" class="tbl_popup pop_tblType1">
                            <tr>
                                <th class="text-center">작성일자</th>
                                <td><input type="text" id="txt_DT" name="txtcreateDate" value="" /></td>
                                <th class="text-center">공급가액</th>
                                <td><span id="sp_sUpMoney"></span></td>
                                <th class="text-center">세액</th>
                                <td><span id="sp_taxMoney"></span></td>
                            </tr>
                            <tr>
                                <th class="text-center">거래일자</th>
                                <td><span id="sp_tradeDt"></span></td>
                                <th class="text-center">품목</th>
                                <td><input type="text" id="txt_Obj" value="" /></td>
                                <th class="text-center">합계금액</th>
                                <td><span id="sp_totalMoney"></span></td>
                            </tr>
                        </table>
                    </div>

                <!-- S. 담당자 정보 테이블 -->
                    <h4 style="padding:0 10px;">담당자 정보</h4>
                    <div class="tblOrder-div">
                        <table id="tblTaxPrintType2" class="tbl_popup pop_tblType2">
                            <thead>
                                <tr>
                                    <th class="text-center">담당자정보</th>
                                    <th class="text-center">담당자</th>
                                    <th class="text-center">부서</th>
                                    <th class="text-center">연락처</th>
                                    <th class="text-center">이메일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th class="text-center bgColor">공급자</th>
                                    <td><input type="text" id="txt_sUser" value="" /></td>
                                    <td><input type="text" id="txt_sDivision" value="" /></td>
                                    <td><input type="text" id="txt_sTelNo" value="" /></td>
                                    <td><input type="text" id="txt_sEmail" value="" /></td>
                                </tr>
                                <tr>
                                    <th class="text-center bgColor">공급받는자</th>
                                    <td><input type="text" id="txt_rUser" value="" /></td>
                                    <td><input type="text" id="txt_rDivision" value="" /></td>
                                    <td><input type="text" id="txt_rTelNo" value="" /></td>
                                    <td><input type="text" id="txt_rEmail" value="" /></td>
                                </tr>
                            </tbody>
                        </table>
                    <!-- E. 담당자 정보 테이블 -->
                    </div>
                <!-- S. 세금계산서 팝업 발행 버튼 영역 -->
                    <div id="divPopBtn" class="btn_center">
                        <a href="#none" id="btnTaxBillPrint" class="mainbtn type1" style="width:110px">세금계산서 발행</a>
                        <a href="#none" id="btnPopClose" class="mainbtn type2" style="width:110px" onclick="fnPopClose(); return false;">닫기</a>
                        <input type="hidden" id="hdPopOrdCodeNo" />
                    </div>
                <!-- E. 세금계산서 팝업 발행 버튼 영역 -->
                </div>
            </div>
        </div>
        <!-- E. 세금계산서 팝업 -->


</asp:Content>

