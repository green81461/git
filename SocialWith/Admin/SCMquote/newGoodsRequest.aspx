<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="newGoodsRequest.aspx.cs" Inherits="Admin_SCMquote_newGoodsRequest" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/SysList/system.css" rel="stylesheet" />
    <link href="../Content/Company/company.css" rel="stylesheet" />
   
    <script type="text/javascript">
        $(document).ready(function () {
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
                buttonImage:/* "/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
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

            $('#tblData input[type="checkbox"]').change(function () {
                if ($(this).prop('checked') == true) {
                    var num = $(this).val();
                    var newDate = new Date($("#<%=this.txtSearchEdate.ClientID%>").val());
                    var resultDate = new Date();
                    resultDate.setDate(newDate.getDate() - num);
                    $("#<%=this.txtSearchSdate.ClientID%>").val($.datepicker.formatDate("yy-mm-dd", resultDate));
                }
            });
            fnSearch(1);
        });

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

                        asynTable += "<tr><td rowspan='2' id='tdReqNo'>" + value.NewGoodsReqNo + "</td>";
                        asynTable += "<td>" + categoryName + "</td>";
                        asynTable += "<td>" + value.OptionValue + "</td>";
                        asynTable += "<td rowspan='2' class='text-center'>" + value.GoodsModel + "</td>";
                        asynTable += "<td>" + value.GoodsOriginName + "</td>";
                        asynTable += "<td rowspan='2' class='text-center'>" + numberWithCommas(value.ProspectGoodsQty) + "개</td>";
                        asynTable += "<td rowspan='2' style='padding-right: 5px; text-align: right;'>" + numberWithCommas(value.NewGoodsPriceVat) + "원</td>";
                        asynTable += "<td rowspan='2' style='text-align:left'><pre style='height:90%'>" + value.NewGoodsExplanDetail + "</pre></td>";
                        asynTable += "<td rowspan='2' style='text-align:left'><pre style='height:90%'>" + value.NewGoodsReqSubject + "</pre></td>";
                        asynTable += "<td rowspan='2' class='text-center'>";
                        asynTable += "<input type= 'hidden' id='hdFileName' value= '" + value.Attach_P_Name + "' />";
                        asynTable += "<input type= 'hidden' id='hdFilePath' value= '" + value.Attach_Path + "' />";
                        asynTable += "<input type= 'hidden' id='hdStatus' value= '" + value.ProcessStatus + "' />";
                        asynTable += "<a onclick= 'fnFileDownload(this); return false;' style= 'cursor: pointer; text-decoration:none; color:blue;' > " + value.Attach_P_Name + "</a ></td > ";
                        asynTable += "<td rowspan='2'>" + value.Name + "<br/>(" + value.CompanyName + ")</td>";
                        asynTable += "<td rowspan='2' class='text-center'>" + value.EntryDate.split("T")[0] + "</td>";
                        asynTable += "<td rowspan='2' class='text-center'>" + value.ProcessName + "</td>";
                        asynTable += "<td rowspan='2' class='text-center'><a onclick= 'fnOpenPopup(this); return false;' style= 'cursor: pointer; text-decoration:none; color:blue;' > " + status + "</a></td ></tr>";

                        //---------------------------------------다음행------------------------------------------------------------------

                        asynTable += "<tr><td>" + value.GoodsFinalName + "</td>";
                        asynTable += "<td>" + value.BrandName + "</td>";
                        asynTable += "<td>" + value.GoodsUnitName + "</td></tr>";
                    });

                } else {
                    asynTable += "<tr><td colspan='14' class='txt-center'>" + "조회된 요청현황이 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);

                }
                $("#tblNewGoods tbody").append(asynTable);

                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, 20, getPageData);
            }

            var sUser = '<%= Svid_User%>';

            param = { TodateB: startDate, TodateE: endDate, Method: 'AdminNewGoodsRequestList', PageNo: pageNum, PageSize: pageSize };
            JajaxSessionCheck('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback, sUser);
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
            window.location = '/Order/FileDownload.aspx?FilePath=' + hdFilePath + '&FileName=' + hdFileName;
            return false;
        }

        function fnOpenPopup(el) {

            var reqNo = $(el).parent().parent().find('#tdReqNo').text();
            var status = $(el).parent().parent().children().find('#hdStatus').val();
           
            $('#<%= hfReqNo.ClientID%>').val(reqNo);
            $('#<%= ddlStatus.ClientID%>').val(status);

            fnOpenDivLayerPopup('modifyDiv');
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">
            <!--제목영역-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    신규견적요청
                    <span class="span-title-subsentence"></span>
                </p>
            </div>

            <span style="color: #69686d; float: right; margin-top: 10px; padding-bottom: 5px;">*<b style="color: #ec2029; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</span>
            <br />

            <table class="tbl_main" id="tblData">
                <tr>
                    <th style="width: 200px">요청일</th>
                    <td colspan="3">
                        <asp:TextBox ID="txtSearchSdate" runat="server" CssClass="calendar" ReadOnly="true" Height="24px" Width="200px" Onkeypress="return fnEnter();"></asp:TextBox>&nbsp;&nbsp;
                            -
                            &nbsp;&nbsp;<asp:TextBox ID="txtSearchEdate" runat="server" CssClass="calendar" ReadOnly="true" Height="24px" Width="200px" Onkeypress="return fnEnter();"></asp:TextBox>&nbsp;&nbsp;
                            <input type="checkbox" id="ckbSearch2" value="7" checked="checked" /><label for="ckbSearch2">7일</label>
                        <input type="checkbox" id="ckbSearch3" value="15" /><label for="ckbSearch3">15일</label>
                        <input type="checkbox" id="ckbSearch4" value="30" /><label for="ckbSearch4">30일</label>
                        <asp:Button runat="server" CssClass="mainbtn type1" Width="75" Height="30" ID="btnSearch" OnClientClick="fnSearch(1); return false;" Text="검색" />
                    </td>
                </tr>
            </table>

            <div class="profitList-div">
                <table id="tblNewGoods" class="tbl_main">
                    <colgroup>
                        <col style="width: 5%;" /> 
                        <%--요청번호--%>
                        <col style="width: 7%;" />
                        <%--카테고리 / 상품명--%>
                        <col style="width: 5%;" />
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
                        <col style="width: 7%;" />
                        <%--신청자(구매자)--%>
                        <col style="width: 5%;" />
                        <%--신청일--%>
                        <col style="width: 3%;" />
                        <%--처리담당자--%>
                        <col style="width: 4%;" /> 
                        <%--진행현황--%>
                    </colgroup>
                    <thead>
                            <tr>
                                <th rowspan="2">요청<br />번호</th>
                                <th>카테고리</th>
                                <th>규격</th>
                                <th rowspan="2">모델명</th>
                                <th>원산지</th>
                                <th rowspan="2">예상<br />
                                    구매수량</th>
                                <th rowspan="2">기존단가</th>
                                <th rowspan="2">품목<br />
                                    상세설명</th>
                                <th rowspan="2">요청사항</th>
                                <th rowspan="2">첨부파일</th>
                                <th rowspan="2">신청자<br />
                                    (구매사)</th>
                                <th rowspan="2">신청일</th>
                                <th rowspan="2">처리<br />
                                    담당자</th>
                                <th rowspan="2">진행현황</th>
                            </tr>
                            <tr>
                                <th>상품명</th>
                                <th>제조사</th>
                                <th>단위</th>
                            </tr>
                        </thead>

                        <tbody>
                        </tbody>
                    </table>

                </div>
            <%-- 엑셀 저장 --%>
             <div class="bt-align-div">
                 <asp:Button runat="server" ID="btnExcelDownLoad" OnClick="btnExcelDownLoad_Click" Width="200" Height="30" Text="신규견적요청 엑셀저장" CssClass="mainbtn type1" />
                </div>
            <br />


            <input type="hidden" id="hdTotalCount" />
            <!-- 페이징 처리 -->
            <div style="margin: 0 auto; text-align: center">
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
            </div>
        </div>
    </div>
    <%-- 진행현황 업데이트 팝업 --%>

    <div id="modifyDiv" class="popupdiv divpopup-layer-package">
                <div class="popupdivWrapper" style="border: none; width:710px; height: 310px">
                    <div class="popupdivContents">

                    <div class="pop-title-div">
                         <h3 class="pop-title">신규견적요청 진행관리</h3>
                          <Button type="button" onclick="fnClosePopup('modifyDiv'); return false;" class="close-bt" style="float:right"><img src="../../Images/Wish/icon-delete.jpg" /></Button>                       
                    </div>
           
                    <div class="divpopup-layer-conts">
                            <table style="width: 100%" id="tblModify" class="tbl_main tbl_pop">
                            <tr class="board-tr-height">
                                <th class="txt-center">처리담당자</th>
                                <td class="txt-center"><asp:Label runat="server" ID="lblAdmin"></asp:Label></td>
                            </tr>
                            <tr class="board-tr-height">
                                <th class="txt-center" style="width: 100px">진행현황</th>
                                <td class="txt-center" style="width: 100px">
                                    <asp:DropDownList runat="server" ID="ddlStatus" Width="90%">
                                        <asp:ListItem Value="N" Text="접수중"></asp:ListItem>
                                        <asp:ListItem Value="A" Text="접수완료"></asp:ListItem>
                                        <asp:ListItem Value="Y" Text="처리완료"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                        </table>
                        <br />
                        <div style="text-align: right; margin-top:20px;">
                            <asp:HiddenField runat="server" ID="hfReqNo" />
                            <%--<asp:ImageButton ID="ibtnSave" runat="server"  AlternateText="저장" ImageUrl ="../Images/Order/save.jpg" onmouseover="this.src='../Images/Order/save-on.jpg'" onmouseout="this.src='../Images/Order/save.jpg'" OnClick="ibtnSave_Click"/>--%>
                            <asp:Button ID="ibtnSave" runat="server" Width="75" Class="mainbtn type1"  Text="저장" OnClick="ibtnSave_Click"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
   
    <%-- 진행현황 업데이트 팝업 --%>
</asp:Content>

