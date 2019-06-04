<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="NewGoodsRequestList.aspx.cs" Inherits="Goods_NewGoodsRequestList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/SysList/system.css" rel="stylesheet" />
    <script src="../Scripts/jquery.inputmask.bundle.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#<%=this.txtSearchSdate.ClientID%>").inputmask("9999-99-99");
            $("#<%=this.txtSearchEdate.ClientID%>").inputmask("9999-99-99");
            //체크박스 하나만 선택
            var tableid = 'tblData';
            ListCheckboxOnlyOne(tableid);

            initDate();

            //달력
            $("#<%=this.txtSearchSdate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../Images/Goods/calendar.jpg",
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
                buttonImage:/* "/Images/icon_calandar.png"*/"../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });

            $('#tblData input[type="checkbox"]').change(function () {
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

        function initDate() {

            $("#<%=this.txtSearchEdate.ClientID%>").val($.datepicker.formatDate("yy-mm-dd", new Date()));

            var newDate = new Date($("#<%=this.txtSearchEdate.ClientID%>").val());
            var resultDate = new Date();
            resultDate.setDate(newDate.getDate() - 7);

            $("#<%=this.txtSearchSdate.ClientID%>").val($.datepicker.formatDate("yy-mm-dd", resultDate));
        }

        function fnEnter() {
            if (event.keyCode == 13) {
                fnSearch(1);
                return false;
            }
            else
                return true;
        }

        //조회하기
        function fnSearch(pageNum) {
            var startDate = $('#<%= txtSearchSdate.ClientID%>').val();
            var endDate = $('#<%= txtSearchEdate.ClientID%>').val();
            var pageSize = 20;
            var i = 1;
            var asynTable = "";

            var callback = function (response) {
                $("#tblNewGoods tbody").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {

                        $("#hdTotalCount").val(value.TotalCount);
                        var status = value.ProcessStatus;
                        if (status != '') {
                            if (status == 'N') {
                                status = "접수중";
                            } else if (status == 'A') {
                                status = "접수완료";
                            } else if (status == 'Y') {
                                status = "처리완료";
                            }
                        } else {
                            status = '';
                        }
                        var categoryName = value.GoodsFinalCategoryName;
                        if (value.GoodsFinalCategoryCode == 'etc') {
                            categoryName = "기타";
                        } else if (value.GoodsFinalCategoryCode == 'etc2') {
                            categoryName = "공사/용역/서비스";
                        }

                        asynTable += "<tr style='height:30px'><td rowspan='2' class='border-right'>" + value.NewGoodsReqNo + "</td>";
                        asynTable += "<td class='border-right'>" + categoryName + "</td>";
                        asynTable += "<td  class='txt-center border-right'>" + value.OptionValue + "</td>";
                        asynTable += "<td rowspan='2' class='txt-center border-right'>" + value.GoodsModel + "</td>";
                        asynTable += "<td  class='txt-center border-right'>" + value.GoodsOriginName + "</td>";
                        asynTable += "<td rowspan='2' class='border-right' style='text-align:right'>" + numberWithCommas(value.ProspectGoodsQty) + "개</td>";
                        asynTable += "<td rowspan='2' class='border-right' style='text-align:right'>" + numberWithCommas(value.NewGoodsPriceVat) + "원</td>";
                        asynTable += "<td rowspan='2' class='border-right' style='text-align:left'><pre style='height:90%'>" + value.NewGoodsExplanDetail + "</pre></td>";
                        asynTable += "<td rowspan='2'class='border-right' style='text-align:left'><pre style='height:90%'>" + value.NewGoodsReqSubject + "</pre></td>";
                        asynTable += "<td rowspan='2' class='border-right'>";
                        asynTable += "<input type= 'hidden' id='hdFileName' value= '" + value.Attach_P_Name + "' />";
                        asynTable += "<input type= 'hidden' id='hdFilePath' value= '" + value.Attach_Path + "' />";
                        asynTable += "<a onclick= 'fnFileDownload(this); return false;' style= 'cursor: pointer; text-decoration:none; color:blue;' > " + value.Attach_P_Name + "</a ></td > ";
                        asynTable += "<td rowspan='2'  class='txt-center border-right'>" + value.Name + "</td>";
                        asynTable += "<td rowspan='2'  class='txt-center border-right'>" + value.EntryDate.split("T")[0] + "</td>";
                        asynTable += "<td rowspan='2'  class='txt-center border-right'>" + value.ProcessName + "</td>";
                        asynTable += "<td rowspan='2'  class='txt-center'>" + status + "</td></tr >";

                        //---------------------------------------다음행------------------------------------------------------------------

                        asynTable += "<tr  style='height:30px'><td class='border-right'>" + value.GoodsFinalName + "</td>";
                        asynTable += "<td  class='txt-center border-right'>" + value.BrandName + "</td>";
                        asynTable += "<td  class='txt-center border-right'>" + value.GoodsUnitName + "</td></tr>";
                    });

                } else {
                    asynTable += "<tr ><td colspan='14' class='txt-center'>" + "조회된 요청현황이 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);

                }
                $("#tblNewGoods tbody").append(asynTable);

                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, 20, getPageData);
            }

            var sUser = '<%= Svid_User%>';
            param = { SvidUser: sUser, TodateB: startDate, TodateE: endDate, Method: 'NewGoodsRequestList', PageNo: pageNum, PageSize: pageSize };
            JajaxSessionCheck('Post', '../Handler/GoodsHandler.ashx', param, 'json', callback, sUser);
        }

        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
            return false;
        }

        function fnFileDownload(el) {

            var hdFilePath = $(el).parent().parent().find("input:hidden[id=hdFilePath]").val();
            var hdFileName = $(el).parent().parent().find("input:hidden[id=hdFileName]").val();
            window.location = '../Order/FileDownload.aspx?FilePath=' + hdFilePath + '&FileName=' + hdFileName;
            return false;
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


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">
            <!--제목영역-->
            <div class="sub-title-div">
                <img src="/images/NewGoodsRequestMain_nam.png" /> 
              <%--  <p class="p-title-mainsentence">
                    신규견적요청 
                </p>--%>
            </div>

            <!--탭영역-->
            <div class="div-main-tab">
                <ul>
                    <li class='tabOff' onclick="location.href='NewGoodsRequestMain.aspx'">
                        <a href="NewGoodsRequestMain.aspx">신규견적요청</a>
                    </li>
                    <li class='tabOn' onclick="location.href='NewGoodsRequestList.aspx'">
                        <a href="NewGoodsRequestList.aspx" >요청현황</a>
                    </li>
                </ul>
            </div>
            <!--테이블 영역-->
            <span style="color: #69686d; float: right; margin-top: 10px;">*<b style="color: #ec2029; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</span>
            <br />

            <table class="tbl_main" id="tblData">
                <tr>
                    <th style="width: 200px" class="border-right">요청일</th>
                    <td colspan="2" class="align-left">
                        <asp:TextBox ID="txtSearchSdate" type="date" runat="server" MaxLength="10" CssClass="calendar" onkeypress="return fnEnterDate();" placeholder="2018-01-01" ReadOnly="true"></asp:TextBox>
                        -
                            <asp:TextBox ID="txtSearchEdate" type="date" runat="server" MaxLength="10" CssClass="calendar" onkeypress="return fnEnterDate();" placeholder="2018-12-30" ReadOnly="true"></asp:TextBox>
                        &nbsp;&nbsp;&nbsp;
                            <input type="checkbox" style="vertical-align:middle;" name="chkBox" id="ckbSearch1" value="1" checked="checked" /><label for="ckbSearch1">1일</label>
                        <input type="checkbox" style="vertical-align:middle; margin-left:5px;" name="chkBox" id="ckbSearch2" value="7" /><label for="ckbSearch2">7일</label>
                        <input type="checkbox" style="vertical-align:middle; margin-left:5px;" name="chkBox" id="ckbSearch3" value="15" /><label for="ckbSearch3">15일</label>
                        <input type="checkbox" style="vertical-align:middle; margin-left:5px;" name="chkBox" id="ckbSearch4" value="30" /><label for="ckbSearch4">30일</label>
                        <input type="checkbox" style="vertical-align:middle; margin-left:5px;" name="chkBox" id="ckbSearch5" value="90" /><label for="ckbSearch5">90일</label>
                        <input type="checkbox" style="vertical-align:middle; margin-left:5px;" name="chkBox" id="ckbSearch6" value="0" /><label for="ckbSearch6">직접입력</label>
                        &nbsp;&nbsp;&nbsp;  
                         <input type="button" class="mainbtn type1" style="width:95px; height:30px; font-size:12px" value="검색" onclick="fnSearch(1); return false;"/>
                    </td>

                </tr>
            </table>
             <br />
            <div style="overflow-x: scroll; clear: both;">
                <div class="profitList-div" style="width: 1500px; height: auto;">
                    <table id="tblNewGoods" class="tbl_main tbl_main2" style="width:100%">
                          <colgroup>
                        <col style="width: 5%;" /> 
                        <%--요청번호--%>
                        <col style="width: 7%;" />
                        <%--카테고리 / 상품명--%>
                        <col style="width: 4%;" /> 
                        <%--규격 / 제조사--%>
                        <col style="width: 7%;" />
                        <%--모델명--%>
                        <col style="width: 5%;" /> 
                        <%--원산지 / 단위--%>
                        <col style="width: 4%;" /> 
                        <%--예상 구매수량--%>
                        <col style="width: 5%;" /> 
                        <%--기존단가--%>
                        <col style="width: 16%;" />
                        <%--품목 상세설명--%>
                        <col style="width: 16%;" />
                        <%--요청사항--%>
                        <col style="width: 7%;" />
                        <%--첨부파일--%>
                        <col style="width: 6%;" />
                        <%--신청자(구매자)--%>
                        <col style="width: 5%;" /> 
                        <%--신청일--%>
                        <col style="width: 4%;" /> 
                        <%--처리담당자--%>
                        <col style="width: 5%;" /> 
                        <%--진행현황--%>
                    </colgroup>
                        <thead>
                            <tr>
                                <th rowspan="2" class="border-right">요청<br />
                                    번호</th>
                                <th class="border-right">카테고리</th>
                                <th class="border-right">규격</th>
                                <th rowspan="2" class="border-right">모델명</th>
                                <th class="border-right">원산지</th>
                                <th rowspan="2" class="border-right">예상<br />
                                    구매수량</th>
                                <th rowspan="2" class="border-right">기존단가</th>
                                <th rowspan="2" class="border-right">품목<br />
                                    상세설명</th>
                                <th rowspan="2" class="border-right">요청사항</th>
                                <th rowspan="2" class="border-right">첨부파일</th>
                                <th rowspan="2" class="border-right">신청자<br />
                                    (구매사)</th>
                                <th rowspan="2" class="border-right">신청일</th>
                                <th rowspan="2" class="border-right">처리<br />
                                    담당자</th>
                                <th rowspan="2">진행현황</th>
                            </tr>
                            <tr>
                                <th class="border-right">상품명</th>
                                <th class="border-right">제조사</th>
                                <th class="border-right">단위</th>
                            </tr>
                        </thead>

                        <tbody>
                           
                        </tbody>
                    </table>

                </div>
            </div>
            <br />
            <input type="hidden" id="hdTotalCount" />
            <!-- 페이징 처리 -->
            <div style="margin: 0 auto; text-align: center">
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
            </div>
            <div class="left-menu-wrap" id="divLeftMenu">
                <dl>
                    <dt>
                        <strong>주문정보</strong>
                    </dt>
                    <dd>
                                <a href="/Cart/CartList.aspx">장바구니</a>
                    </dd>
                    <dd>
                        <a href="/Wish/WishList.aspx">위시상품 리스트</a>
                    </dd>
                    <dd>
                        <a href="/Goods/GoodsRecommListSearch.aspx">견적상품게시판</a>
                    </dd>
                    <dd class="active">
                        <a href="/Goods/NewGoodsRequestMain.aspx">신규견적요청</a>
                    </dd>
                </dl>
        </div>
        </div>
    </div>
</asp:Content>

