<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="RecommListSearch.aspx.cs" Inherits="Admin_Goods_RecommListSearch" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
 
    <script>
        $(document).ready(function () {
            $("#<%=this.txtSearchSdate.ClientID%>").inputmask("9999-99-99");
            $("#<%=this.txtSearchEdate.ClientID%>").inputmask("9999-99-99");


            //체크박스 하나만 선택
            var tableid = 'tblSearchList';
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

            $('#tblSearchList input[type="checkbox"]').change(function () {
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
            fnSearch(1);
        });

        //달력 자동 세팅 함수  
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
        var is_sending = false;
        //조회하기
        function fnSearch(pageNum) {

            var startDate = $('#<%= txtSearchSdate.ClientID%>').val();  //시작일자
            var endDate = $('#<%= txtSearchEdate.ClientID%>').val();   //종료일자
            var schName = $('#<%= txtName.ClientID%>').val();         //제목검색 
            var schAdminName = $('#<%=txtAdminName.ClientID %>').val();  //담당자 검색
            var schRecommNum = $('#<%=txtRecommNum.ClientID %>').val();  //추천번호 검색

            var pageSize = 20;                                  //페이징 처리 사이즈
            var i = 1;                                          //페이징

            var listTag = "";

            var callback = function (response) {
                $("#tblReCommList tbody").empty();

                if (!isEmpty(response)) {


                    $.each(response, function (key, value) {
                        $('#itemPagination').css('display', 'inline-block');
                        $('#hdItemTotalCount').val(value.TotalCount);

                        listTag += "<tr>"
                        listTag += "<td class='txt-center' style='display:none'><input type='checkbox' id='cbItemSelect'></td>";
                        listTag += "<td class='txt-center'><input type='hidden' id='hdRecommCode' value='" + value.GoodsRecommCode + "' />" + value.RowNum + "</td>";
                        listTag += "<td class='txt-center'>" + value.YYYYMMDD + "</td>";
                        listTag += "<td class='txt-center'>" + value.GoodsRecommCode + "</td>";
                        listTag += "<td class='txt-center'>" + value.CompanyType_Name + "</td>";    //업체부분
                        listTag += "<td class='txt-center'>" + value.CompanyName + "</td>";
                        listTag += "<td class='txt-center'>" + value.BuyerName + "</td>";
                        listTag += "<td class='txt-center'>" + value.Subject + "</td>";

                        var goodsNames = '';
                        if (parseInt(value.RecommCount) > 0) {
                            goodsNames = value.GoodsFinalName + " 외 " + value.RecommCount + "건";
                        }
                        else {
                            goodsNames = value.GoodsFinalName;
                        }
                        listTag += "<td class='txt-center'>" + goodsNames+"</td>";
                        listTag += "<td class='txt-center'>" + value.AdminUserName + "</td>";

                        var confirmText = '확인';
                        if (value.ConfirmYn == 'N') {
                            confirmText = '미확인';
                        }
                        listTag += "<td class='txt-center'>" + confirmText + "</td>";
                        listTag += "<td class='txt-center'><input type='button' class='btnDelete' value='상세보기' onclick='return fnDetailView(\"" + value.GoodsRecommCode + "\",\"" + value.ConfirmYn + "\",\"" + value.BuyRecommDelFlag + "\",\"" + value.FreeCompanyVatYN + "\" )'/></td>";
                        listTag += "</tr>";
                    });
                    $("#tblReCommList tbody").append(listTag);
                    fnCreatePagination('itemPagination', $("#hdItemTotalCount").val(), pageNum, 20, getItemPageData);

                } else {
                    var emptyTag = "<tr><td colspan='11' class='txt-center'>조회된 데이터가 없습니다.</td></tr>";
                    $('#itemPagination').css('display', 'none');
                    $("#tblReCommList tbody").append(emptyTag);
                }

                return false;
            };

            var sUser = '<%=Svid_User %>';
            var gubun = 'RC';

            var param = {
                Sdate: startDate,
                Edate: endDate,
                Subject: schName,
                AdminName: schAdminName,
                Code: schRecommNum,
                Gubun: gubun,
                PageNo: pageNum,
                PageSize: pageSize,
                Method: 'GoodsRecommList_Admin'
            };

            var beforeSend = function () {
                 $('#divLoading').css('display', '');
                is_sending = true;
            }
            var complete = function () {
                 $('#divLoading').css('display', 'none');
                is_sending = false;
            }

            if (is_sending) return false;


            JqueryAjax('Post', '../../Handler/GoodsRecommHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }


        function getItemPageData() {
            var container = $('#itemPagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
            return false;
        }


        function fnDetailView(code, ConfirmYn, BuyRecommDelFlag, FreeCompanyVatYN) {
            $('#<%= hdCode.ClientID%>').val(code);
            $('#<%= hdDelFlag.ClientID%>').val(BuyRecommDelFlag);
            if (FreeCompanyVatYN == 'Y') {
                $('#vatChk').text("(VAT 포함)");
                $('#totalVatChk').text("(VAT 포함)");
            }
            else if (FreeCompanyVatYN == 'N') {
                $('#vatChk').text("(VAT 별도)");
                $('#totalVatChk').text("(VAT 별도)");
            }
            else {
                $('#vatChk').text("(VAT 포함)");
                $('#totalVatChk').text("(VAT 포함)");
            }

            if (ConfirmYn == 'Y') {

                $('#<%= btnlistDel.ClientID%>').css("display", "none");
            }
            else {
                $('#<%= btnlistDel.ClientID%>').css("display", "");

            }

            var callback = function (response) {
                $("#tblPopupGoodsRecomm_tbody").empty(); //데이터 클리어
                if (!isEmpty(response)) {

                    var listTag = "";

                    $.each(response, function (key, value) {

                        if (key == 0) {
                            $('#txtPopupSubject').val(value.Subject);
                            $('#txtPopupContent').val(value.Remark);
                        }
                        listTag += "<tr>"
                        listTag += "<td class='txt-center'><input type='checkbox' id='cbPopupItemSelect' checked='checked'/>";
                        listTag += "<input type='hidden' id='hdPopupCategoryCode' value='" + value.GoodsFinalCategoryCode + "' />";
                        listTag += "<input type='hidden' id='hdPopupGroupCode' value='" + value.GoodsGroupCode + "' />";
                        listTag += "<input type='hidden' id='hdPopupGoodsCode' value='" + value.GoodsCode + "' />";
                        listTag += "<input type='hidden' id='hdPopupQty' value='" + value.Qty + "' />";
                        listTag += "<input type='hidden' id='hdPopupPriceVat' value='" + value.GoodsRecommPriceVAT + "' />";
                        listTag += "<input type='hidden' id='hdPopupPrice' value='" + value.GoodsRecommPrice + "' /></td>";
                        listTag += "<td class='txt-center'>" + value.Seq + "</td>";
                        var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-sss.jpg';
                        listTag += "<td style= 'text-align:left; padding-left:5px' ><table style='width:100%;' id='tblGoodsInfo'><tr><td rowspan='2' style='width:14%'><img src=" + src + " onerror='no_image(this, \"s\")' style='width:50px; height=50px'/></td><td style='text-align:left; width:86%'>" + value.GoodsCode + "</td></tr><tr><td style='text-align:left; width:86%'>" + "[" + value.BrandName + "] " + value.GoodsFinalName + "<br/><span style='color:#368AFF; width:86%; word-wrap:break-word; display:block;'>" + value.GoodsOptionSummaryValues + "</span></td></tr></table></td>";
                        listTag += "<td class='txt-center'>" + value.GoodsModel + "</td>";
                        listTag += "<td class='txt-center'>" + value.GoodsUnitName + "</td>";

                        var price = '';
                        if (FreeCompanyVatYN == 'Y') {
                            price = numberWithCommas(value.GoodsRecommPriceVAT);
                        }
                        else {
                            price = numberWithCommas(value.GoodsRecommPrice);
                        }
                        listTag += "<td class='txt-center'>" + price + "원</td>";
                        listTag += "<td class='txt-center'>" + value.Qty + "</td>";

                        var totalPrice = '';
                        if (FreeCompanyVatYN == 'Y') {
                            totalPrice = numberWithCommas(value.GoodsRecommPriceVAT * value.Qty);
                        }
                        else {
                            totalPrice = numberWithCommas(value.GoodsRecommPrice * value.Qty);
                        }

                        listTag += "<td class='txt-center'>" + totalPrice + "원</td>";

                        listTag += "</tr>";
                    });
                    $("#tblPopupGoodsRecomm_tbody").append(listTag);

                } else {
                    var emptyTag = "<tr><td colspan='9' class='txt-center'>조회된 데이터가 없습니다.</td></tr>";
                    $("#tblPopupGoodsRecomm_tbody").append(emptyTag);
                }


                return false;
            };

            var param = {
                Code: code,
                Method: 'GetGoodsRecommDetailList'
            };

            var complete = function () {

               

                fnOpenDivLayerPopup('detailViewDiv');

            };

            JqueryAjax('Post', '../../Handler/GoodsRecommHandler.ashx', true, false, param, 'json', callback, null, complete, true, '<%=Svid_User%>');


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
        function fnEnter() {
            if (event.keyCode == 13) {
                fnSearch(1);
                return false;
            }
            else
                return true;
        }


<%--        function fnDelList() {

            var code = $("#hdCode").val();
            var delFlag = $("#hdDelFlag").val();
        
            var callback = function (response) {

                if (!isEmpty(response)) {

                    alert('삭제 처리가 완료되었습니다.')
                }
                return false;
            };
                
            var param = {
                Code = code,
                DelFlag = delFlag,
                Method: 'GoodsRecommList_Del'
            };

            JajaxSessionCheck('Post', '../../Handler/GoodsRecommHandler.ashx', param, 'json', callback, '<%=Svid_User %>');
        }--%>

        //전체선택
        function fnSelectAll(el) {
            if ($(el).prop("checked")) {
                $("input[id^='cbPopupItemSelect']").not(":disabled").prop("checked", true);
            }
            else {
                $("input[id^='cbPopupItemSelect']").not(":disabled").prop("checked", false);
            }


        }
		function fnDeleteConfirm(){
			if(!confirm('삭제하시겠습니까?')){
				return false;
			}
			return true;
		}

        function fnTabClickRedirect(pageName) {
            location.href = pageName + '.aspx?ucode=' + ucode;
            return false;
        }
    </script>
    <style type="text/css">
        .auto-style2 {
            height: 30px;
        }

        .auto-style3 {
            width: 80px;
            height: 30px;
        }

        .auto-style4 {
            width: 150px;
            height: 30px;
        }

        .auto-style5 {
            width: 200px;
            height: 30px;
        }

        .auto-style6 {
            width: 250px;
            height: 30px;
        }

        .auto-style7 {
            width: 100px;
            height: 30px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">
            <%--제목타이틀--%>
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    추천 상품
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%; ">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('RecommManagement');">
                        <a onclick="fnTabClickRedirect('RecommManagement');">추천상품 생성</a>
                     </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('RecommListSearch');">
                         <a onclick="fnTabClickRedirect('RecommListSearch');">생성 리스트 조회</a>
                    </li>
                </ul>
            </div>

            <div class="search-div">
                <table id="tblSearchList" class="tbl_main">
                    <colgroup>
                        <col style="width:200px"/>
                        <col />
                        <col style="width:200px"/>
                        <col />
                    </colgroup>
                    <tr>
                        <th>주문일</th>
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
                        <th>제목 검색</th>
                        <td colspan="3">
                            <asp:TextBox runat="server" CssClass="large-size" ID="txtName" onkeypress="return fnEnter();"></asp:TextBox></td>

                    </tr>
                    <tr>
                        <th>담당자 검색</th>
                        <td>
                            <asp:TextBox runat="server" CssClass="large-size" ID="txtAdminName" onkeypress="return fnEnter();"></asp:TextBox></td>
                        <th>추천번호 검색
                        </th>
                        <td>
                            <asp:TextBox runat="server" CssClass="large-size" ID="txtRecommNum" onkeypress="return fnEnter();"></asp:TextBox>
                        </td>

                    </tr>
                </table>
            </div>




            <div style="float: right; margin-bottom: 50px; margin-top: 20px;">
                <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="조회하기" onclick="fnSearch(1); return false;" />
            </div>


            <div class="list-div" style="margin-top: 10px !important">
                <table class="tbl_main" id="tblReCommList">
                    <thead>
                        <tr>
                            <th style="width: 80px; display: none">선택</th>
                            <th style="width: 80px">번호</th>
                            <th style="width: 80px">일자</th>
                            <th style="width: 150px">추천번호</th>
                            <th style="width: 150px">업체구분</th>
                            <th style="width: 180px">구매사명</th>
                            <th style="width: 150px">구매자명</th>
                            <th style="width: 200px">제목</th>
                            <th style="width: 250px">상품</th>
                            <th style="width: 80px">담당자</th>
                            <th style="width: 80px">확인여부</th>
                            <th style="width: 100px">팝업보기</th>

                            <%--  <th style="display: none" class="auto-style2">선택</th>
                            <th class="auto-style3">번호</th>
                            <th class="auto-style3">일자</th>
                            <th class="auto-style4">추천번호</th>
                            <th class="auto-style5">업체구분</th>
                            <th class="auto-style5">제목</th>
                            <th class="auto-style6">상품</th>
                            <th class="auto-style3">담당자</th>
                            <th class="auto-style3">확인여부</th>
                            <th class="auto-style7">팝업보기</th>--%>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="11" style="text-align: center">조회된 내역이 없습니다.!
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                    <input type="hidden" id="hdItemTotalCount" />
                    <div id="itemPagination" class="page_curl" style="display: inline-block"></div>
                </div>
            </div>

        </div>
    </div>
    <!--엑셀 저장-->
    <div class="bt-align-div">
        <%--<asp:ImageButton AlternateText="엑셀저장" runat="server" ImageUrl="../../Images/Cart/excel-off.jpg" onmouseover="this.src='../../Images/Cart/excel-on.jpg'" onmouseout="this.src='../../Images/Cart/excel-off.jpg'" />--%>
    </div>
    <div style="margin: 0 auto; text-align: center">
        <input type="hidden" id="hdTotalCount">
        <div id="pagination" class="page_curl" style="display: inline-block"></div>
    </div>



    <%--상세 팝업--%>
    <div id="detailViewDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 1000px; height: 800px;">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('detailViewDiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title" >
                    <h3 class="pop-title">추천상품</h3>
                </div>
                <div class="divpopup-layer-conts">
                    <table class="tbl_main tbl_pop">
                        <colgroup>
                            <col style="width:200px"/>
                            <col />
                        </colgroup>
                        <tr>
                            <th>제목
                            </th>
                            <td>
                                <input type="text" id="txtPopupSubject" readonly="readonly" style="width: 100%"/>
                            </td>
                        </tr>
                        <tr>
                            <th>상세사항
                            </th>
                            <td>
                                <textarea style="width: 100%" id="txtPopupContent" rows="5" readonly="readonly"></textarea>
                            </td>
                        </tr>
                    </table>
                     <div class="divpopup-layer-conts">
                        <table class="tbl_main tbl_pop" >
                            <thead>
                                <tr>
                                    <th class="text-center" style="width:30px">
                                        <input type="checkbox" id="selectAllItem" checked="checked" onclick="fnSelectAll(this);"></th>
                                    <th class="text-center" style="width:40px">번호</th>
                                    <th class="text-center" style="width:330px">상품정보</th>
                                    <th class="text-center" style="width:100px">모델명</th>
                                    <th class="text-center" style="width:80px">단위</th>
                                    <th class="text-center" style="width:90px">상품가격<br />
                                        <span id="vatChk"></span></th>
                                    <th class="text-center" style="width:60px">수량</th>
                                    <th class="text-center" style="width:90px">합계금액<br />
                                        <span id="totalVatChk"></span></th>
                                </tr>
                            </thead>
                            <tbody id="tblPopupGoodsRecomm_tbody">
                                <tr>
                                    <td colspan="7" class="text-center">리스트가 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="btn_center">
                    <asp:HiddenField ID="hdCode" Value="" runat="server" />
                    <asp:HiddenField ID="hdDelFlag" Value="" runat="server" />

                    <asp:Button runat="server" ID="btnlistDel" CssClass="mainbtn type1" Text="리스트 삭제" onclientclick="return fnDeleteConfirm();" OnClick="click_Delete" Style="width: 95px; height: 30px; font-size: 12px" />

                    <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="닫기" onclick="fnClosePopup('detailViewDiv'); return false;" />
                </div>

            </div>
        </div>
    </div>
</asp:Content>

