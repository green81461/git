<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="GoodsHistoryList.aspx.cs" Inherits="Admin_Goods_GoodsHistoryList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
       <link href="../Content/Goods/goods.css" rel="stylesheet" />

     <script>
        $(document).ready(function () {
            //체크박스 하나만 선택
            var tableid = 'Search-table';
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

            $('#Search-table input[type="checkbox"]').change(function () {
                if ($(this).prop('checked') == true) {
                    var num = $(this).val();
                    var newDate = new Date($("#<%=this.txtSearchEdate.ClientID%>").val());
                    var resultDate = new Date();
                    resultDate.setDate(newDate.getDate() - num);
                    $("#<%=this.txtSearchSdate.ClientID%>").val($.datepicker.formatDate("yy-mm-dd", resultDate));
                }
            });

</script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <div class="all">

        <div class="sub-contents-div" style="min-height:1500px">
            <div class="sub-title-div">
                <img src="../Images/Goods/goodsInsert-title.jpg" alt="상품등록 및 수정" />

            </div>

            <!--탭메뉴-->
            <div class="sub-tab-div">
                <ul>
                    <li>
                        <a href="GoodsRegister.aspx">
                            <img src="../Images/Goods/tab1-off.jpg" alt="상품등록" /></a>
                        <a href="GoodsModify.aspx">
                            <img src="../Images/Goods/tab2-off.jpg" alt="상품수정" /></a>
                          <a href="GoodsHistoryList.aspx">
                            <img src="../Images/Goods/tab3-on.jpg" alt="상품정보이력" /></a>
                    </li>
                </ul>
            </div>

            <!--상단 조회 영역 시작-->
        <div class="search-div">
            <table id="Search-table">
                <thead><tr><th colspan="4">상품정보이력 조회</th></tr></thead>
            
                <tr><th>조회기간</th>
                    <td style="width:400px" colspan="3">  
                            <asp:TextBox ID="txtSearchSdate" runat="server" CssClass="calendar" ReadOnly="true" ></asp:TextBox>
                            -
                            <asp:TextBox ID="txtSearchEdate" runat="server" CssClass="calendar" ReadOnly="true"></asp:TextBox>&nbsp;&nbsp;&nbsp;
                        
                            <asp:CheckBoxList runat="server" ID="cblDate"  RepeatLayout="Flow" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Value="7" Text="7일"></asp:ListItem>
                                <asp:ListItem Value="15" Text="15일"></asp:ListItem>
                                <asp:ListItem  Value="30" Text="30일"></asp:ListItem>
                            </asp:CheckBoxList>
                    </td>
                  
                </tr>
                <tr>
                    <th>이력구분</th>
                    <td>
                       <asp:DropDownList runat="server" ID="DropDownList1" CssClass="input-drop">
						    <asp:ListItem Value="all">---전체---</asp:ListItem>
					    </asp:DropDownList>

                    </td>
                    <th>담당자</th>
                    <td>
                      <asp:DropDownList runat="server" ID="DropDownList2" CssClass="input-drop">
						    <asp:ListItem Value="all">---전체---</asp:ListItem>
					    </asp:DropDownList>            </td>
                 </tr>
            </table>
        </div>
<!--조회하기 버튼-->
        <div class="bt-align-div">
            <a><img alt="조회하기" src="../../Images/Goods/aslist.jpg" id="btnSearch" onclick="fnSearch(1); return false;" onmouseover="this.src='../../Images/Wish/aslist-over.jpg'" onmouseout="this.src='../../Images/Goods/aslist.jpg'" /></a>
        </div>


            <!--하단리스트영역 시작-->
        <div class="list-div">
            
            <table id="list-table" class="TblSearch">       
                <thead>
                    <tr>
                        <th style="width:80px;" >No.</th>
                        <th style="width:130px;">이력구분</th>
                        <th style="width:80px;">이미지</th>
                        <th style="width:100px;">상품코드</th>
                        <th style="width:180px;">상품정보</th>
                        <th style="width:100px;" >모델명</th>
                        <th style="width:150px;" >담당부서</th>
                        <th style="width:120px;">담당자</th>
                        <th style="width:70px;">변경일시</th>
                        <th style="width:200px;">변경내용</th>
                       
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
            <!--데이터 리스트 종료 -->

         </div>

        <!-- 페이징 처리 -->
        <div style="margin: 0 auto; text-align: center">
            <input type="hidden" id="hdTotalCount" />
            <div id="pagination" class="page_curl" style="display: inline-block"></div>
        </div>


        <!--엑셀저장버튼-->
        <div class="bt-align-div"><img src="../../Images/Cart/excel-off.jpg" alt="엑셀저장" onmouseover="this.src='../../Images/Cart/excel-on.jpg'" onmouseout="this.src='../../Images/Cart/excel-off.jpg'"/></div>




            </div>
         </div>
</asp:Content>

